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

            trigger OnAfterGetRecord()
            begin
                CalcFields("Balance (LCY)");
                TempExcelBuffer.NewRow();
                AddCell(Customer."No.", false, TempExcelBuffer."Cell Type"::Text);
                AddCell(Customer.Name, false, TempExcelBuffer."Cell Type"::Text);
                AddCell(Customer."Country/Region Code", false, TempExcelBuffer."Cell Type"::Text);
                AddCell(Format(Customer."Balance (LCY)"), false, TempExcelBuffer."Cell Type"::Number);
                AddCell(Format(Customer."Credit Limit (LCY)"), false, TempExcelBuffer."Cell Type"::Number);
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
        layout(ExcelLayout)
        {
            Type = Excel;
            LayoutFile = './CustomerReport.xlsx';
        }
    }

    trigger OnPreReport()
    begin
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.NewRow();
        AddCell(Customer.FieldCaption("No."), true, TempExcelBuffer."Cell Type"::Text);
        AddCell(Customer.FieldCaption(Name), true, TempExcelBuffer."Cell Type"::Text);
        AddCell(Customer.FieldCaption("Country/Region Code"), true, TempExcelBuffer."Cell Type"::Text);
        AddCell(Customer.FieldCaption("Balance (LCY)"), true, TempExcelBuffer."Cell Type"::Number);
        AddCell(Customer.FieldCaption("Credit Limit (LCY)"), true, TempExcelBuffer."Cell Type"::Number);
    end;

    trigger OnPostReport()
    begin
        TempExcelBuffer.CreateNewBook('Customer Report.xlsx');
        TempExcelBuffer.WriteSheet('Customer Report', CompanyName(), UserId());
        TempExcelBuffer.CloseBook();
        TempExcelBuffer.OpenExcel();
    end;


    local procedure AddCell(Value: Text; IsBold: Boolean; CellType: Option)
    begin
        TempExcelBuffer.AddColumn(Value, false, '', IsBold, false, false, '', CellType);
    end;

    var
        tempExcelBuffer: Record "Excel Buffer" temporary;
}