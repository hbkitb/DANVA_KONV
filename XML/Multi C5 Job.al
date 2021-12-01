xmlport 70053 "Multi C5 Job"
{

    Direction = Import;
    FieldDelimiter = '¤';
    FieldSeparator = ';';
    Format = VariableText;
    TextEncoding = WINDOWS;
    Permissions = tabledata "Job Ledger Entry" = rimd, tabledata "Job Task" = rimd;


    schema
    {
        textelement(JobTable)
        {
            tableelement(Job; Job)
            {
                XmlName = 'JobTable';
                fieldelement(JobNumber; Job."No.")
                {
                }
                fieldelement(SearchName; Job."Search Description")
                {
                }
                fieldelement(JobName; Job.Description)
                {
                }
                fieldelement(InvoiceAccount; Job."Bill-to Customer No.")
                {

                    trigger OnAfterAssignField()
                    begin
                        if Cust.Get(Job."Bill-to Customer No.") then begin
                            if Cust.Blocked <> Cust.Blocked::" " then begin
                                Cust.Blocked := Cust.Blocked::" "; //0;
                                Cust.Modify;
                            end;
                        end;
                    end;
                }
                fieldelement(Created; Job."Creation Date")
                {
                }
                fieldelement(Started; Job."Starting Date")
                {
                }
                fieldelement(Delivery; Job."Ending Date")
                {

                    trigger OnAfterAssignField()
                    begin
                        //EVALUATE(Dato,Job."Ending Date");
                        if Job."Ending Date" < Job."Starting Date" then
                            Job."Ending Date" := Job."Starting Date";
                    end;
                }
                /* 050721
                fieldelement(JobStatus; Job.Status)
                {
                }
                */
                fieldelement(JobPostingGroup; Job."Job Posting Group")
                {
                }
                textelement(Ansvarlig)
                {
                }
                fieldelement(CurrencyCode; Job."Currency Code")
                {
                }
                //fieldelement(Language; Job."Language Code")
                textelement(Language)
                {
                    trigger OnAfterAssignVariable()

                    var

                    begin
                        case Language of
                            '0':
                                Job."Language Code" := 'DAN';
                            '1':
                                Job."Language Code" := 'DAN';
                            '2':
                                Job."Language Code" := 'ENU';
                            '3':
                                Job."Language Code" := 'DEU';
                            '4':
                                Job."Language Code" := 'FRA';
                            '5':
                                Job."Language Code" := 'ITA';
                            '6':
                                Job."Language Code" := 'NLD';
                            '7':
                                Job."Language Code" := 'ISL';
                        end;
                    end;
                }
                textelement(OurRef)
                {
                }
                textelement(YourRef)
                {
                }
                textelement(Group)
                {
                }
                textelement(Order)
                {
                }
                textelement(ShipToName)
                {
                }
                textelement(ShipToadd1)
                {
                }
                textelement(ShipToAdd2)
                {
                }
                textelement(ShipToZIp)
                {
                }
                textelement(ShipToCity)
                {
                }
                textelement(ShipToCountry)
                {
                }
                textelement(ShipToAttention)
                {
                }
                textelement(Department)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        if Department <> '' then begin
                            DefaultDimension.Init;
                            DefaultDimension."Table ID" := DATABASE::Job;
                            DefaultDimension."No." := Job."No.";
                            DefaultDimension."Dimension Code" := 'AFDELING';
                            DefaultDimension."Dimension Value Code" := Department;
                            DefaultDimension.Insert;
                        end;
                    end;
                }
                textelement(Centre)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        if Centre <> '' then begin
                            DefaultDimension.Init;
                            DefaultDimension."Table ID" := DATABASE::Job;
                            DefaultDimension."No." := Job."No.";
                            DefaultDimension."Dimension Code" := 'BÆRER';
                            DefaultDimension."Dimension Value Code" := Centre;
                            DefaultDimension.Insert;
                        end;
                    end;
                }
                textelement(Purpose)
                {

                    trigger OnAfterAssignVariable()
                    begin
                        if Purpose <> '' then begin
                            DefaultDimension.Init;
                            DefaultDimension."Table ID" := DATABASE::Job;
                            DefaultDimension."No." := Job."No.";
                            DefaultDimension."Dimension Code" := 'FORMÅL';
                            DefaultDimension."Dimension Value Code" := Purpose;
                            DefaultDimension.Insert;
                        end;
                    end;
                }

                fieldelement(BillToName; Job."Bill-to Name")
                {
                }
                fieldelement(BillToAddr1; Job."Bill-to Address")
                {
                }
                fieldelement(BillToAddr2; Job."Bill-to Address 2")
                {
                }
                fieldelement(BillToZip; Job."Bill-to Post Code")
                {
                }
                fieldelement(BillToCity; Job."Bill-to City")
                {
                }
                fieldelement(BillToCountry; Job."Bill-to Country/Region Code")
                {
                }
                fieldelement(BillToName; Job."Bill-to Contact")
                {
                }

            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        JobEntry.DeleteAll;
        JobPlanningLine.DeleteAll;
        JobTask.DeleteAll;
        Job.DeleteAll;
        DefaultDimension.SetFilter("Table ID", '167');
        DefaultDimension.DeleteAll;
        DefaultDimension.SetFilter("Table ID", '169');
        DefaultDimension.DeleteAll;
        DefaultDimension.SetFilter("Table ID", '1003');
        DefaultDimension.DeleteAll;
        DefaultDimension.SetFilter("Table ID", '1001');
        DefaultDimension.DeleteAll;
        JobTaskDimension.DeleteAll;
        Commit;
    end;

    var
        Cust: Record Customer;
        JobTask: Record "Job Task";
        JobPlanningLine: Record "Job Planning Line";
        JobEntry: Record "Job Ledger Entry";
        JobPostingGroup: Record "Job Posting Group";
        DefaultDimension: Record "Default Dimension";
        JobTaskDimension: Record "Job Task Dimension";
}

