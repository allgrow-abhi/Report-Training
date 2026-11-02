report 50112 "Customer Report AS"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    // DefaultLayout = RDLC;
    // RDLCLayout = './CustomerRDLCReport.rdl';
    DefaultRenderingLayout = WordLayout;
    Caption = 'Customer Report AS';

    dataset
    {
        dataitem(Customer; Customer)
        {
            column(Customer_No; "No.") { }
            column(Customer_Name; Name) { }
            column(Country_Region_Code; "Country/Region Code") { }
            column(Balance__LCY_; "Balance (LCY)") { }
            column(Credit_Limit__LCY_; "Credit Limit (LCY)") { }
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
                group(GroupName)
                {
                    // field(CustomerNo; CustomerNo)
                    // {
                    //     ApplicationArea = all;
                    //     Caption = 'Customer No.';
                    //     TableRelation = Customer."No.";
                    // }
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

    rendering
    {
        layout(WordLayout)
        {
            Type = Word;
            LayoutFile = 'CustomerReport.docx';
        }
        layout(RDLCLayout)
        {
            Type = RDLC;
            LayoutFile = './CustomerReport.rdl';
        }
    }
}