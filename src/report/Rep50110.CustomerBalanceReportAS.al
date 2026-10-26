report 50110 "Customer Balance Report AS"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './CustomerBalanceReport.rdl';
    Caption = 'Customer Balance Report AS';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(CustomerNo; "No.") { }
            column(CustomerName; Name) { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(Country_Region_Code; "Country/Region Code") { }
            column(Balance__LCY_; "Balance (LCY)") { }
            column(Balance_Due__LCY_; "Balance Due (LCY)") { }
            column(Credit_Limit__LCY_; "Credit Limit (LCY)") { }
            column(OverLimit; OverLimit) { }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)", "Balance Due (LCY)");
                OverLimit := ("Credit Limit (LCY)" >= 0) and ("Balance (LCY)" > "Credit Limit (LCY)");
                // Message('OverLimit:%1', OverLimit);
                if CustomerBalance then begin
                    if "Balance (LCY)" = 0 then begin
                        CurrReport.Skip();
                    end;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if SalesPersonCode <> '' then begin
                    SetRange("Salesperson Code", SalesPersonCode);
                end;

                if CountryRegionCode <> '' then begin
                    SetRange("Country/Region Code", CountryRegionCode);
                end;
                if Format(DateFilter) <> '' then begin
                    SetRange("Date Filter", DateFilter);
                end;
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(Filter)
                {
                    field(SalesPersonCode; SalesPersonCode)
                    {
                        Caption = 'Sales Person Code';
                        TableRelation = "Salesperson/Purchaser".Code;
                    }
                    field(CountryRegionCode; CountryRegionCode)
                    {
                        Caption = 'Country Region Code';
                        ApplicationArea = All;
                        TableRelation = "Country/Region".Code;
                    }
                }

                group(Option)
                {
                    field(DateFilter; DateFilter)
                    {
                        ApplicationArea = all;
                        Caption = 'Date Filter';
                    }
                    field(CustomerBalance; CustomerBalance)
                    {
                        ApplicationArea = all;
                        Caption = 'Customers with a Balance';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }

    var
        OverLimit: Boolean;
        SalesPersonCode: Code[50];
        CountryRegionCode: Code[50];
        DateFilter: Date;
        CustomerBalance: Boolean;
}