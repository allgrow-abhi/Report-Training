report 50116 "Custom Sales Invoice AS"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './CustomSalesInvoice.rdl';
    Caption = 'Custom Sales Invoice AS';

    dataset
    {
        dataitem("Sales Invoice Header"; "Sales Invoice Header")
        {
            requestfilterfields = "No.";
            column(Sales_Invoice_No; "No.") { }
            column(Posting_Date; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Bill_to_Customer_No_; "Bill-to Customer No.") { }
            column(bill_to_Name; "Bill-to Name") { }
            column(BillToAdressLine1; BillToAdressLine[1]) { }
            column(BillToAdressLine2; BillToAdressLine[2]) { }
            column(BillToAdressLine3; BillToAdressLine[3]) { }
            column(BillToAdressLine4; BillToAdressLine[4]) { }
            column(BillToAdressLine5; BillToAdressLine[5]) { }
            column(BillToAdressLine6; BillToAdressLine[6]) { }
            column(BillToAdressLine7; BillToAdressLine[7]) { }
            column(ShipToAdressLine1; ShipToAdressLine[1]) { }
            column(ShipToAdressLine2; ShipToAdressLine[2]) { }
            column(ShipToAdressLine3; ShipToAdressLine[3]) { }
            column(ShipToAdressLine4; ShipToAdressLine[4]) { }
            column(ShipToAdressLine5; ShipToAdressLine[5]) { }
            column(ShipToAdressLine6; ShipToAdressLine[6]) { }
            column(ShipToAdressLine7; ShipToAdressLine[7]) { }
            column(ShipToAdressLine8; ShipToAdressLine[8]) { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(currency_Code; "Currency Code") { }
            column(External_Document_No_; "External Document No.") { }
            column(Your_Reference; "Your Reference") { }
            column(Company_Name; CompanyData[1]) { }
            column(Company_Address; CompanyData[2]) { }
            column(Company_VAT_Registration_No; CompanyData[3]) { }
            column(Company_Phone_No; CompanyData[4]) { }
            column(Picture; CompanyInformationRec.Picture) { }
            column(TotalExclVAT; TotalExclVAT) { }
            column(TotalVAT; TotalVAT) { }
            column(TotalInclVAT; TotalInclVAT) { }
            column(ShowInternalInfoCol; ShowInternalInfo) { }
            column(LogInteractionCol; LogInteraction) { }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Line_No; "Line No.") { }
                column(Line_Type; Type) { }
                column(Item_No; "No.") { }
                column(Line_Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure; "Unit of Measure") { }
                column(Unit_Price; "Unit Price") { }
                column(Line_Discount_Pct; "Line Discount %") { }
                column(Line_Amount; "Line Amount") { }
                column(VAT__; "VAT %") { }
                column(Amount_Including_VAT; "Amount Including VAT") { }

                trigger OnAfterGetRecord()
                begin
                    TotalExclVAT += "Line Amount";
                    TotalInclVAT += "Amount Including VAT";
                end;

                trigger OnPostDataItem()
                begin
                    TotalVAT := TotalInclVAT - TotalExclVAT;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                BillToAdressLine[1] := "Sales Invoice Header"."Bill-to Name 2";
                BillToAdressLine[2] := "Sales Invoice Header"."Bill-to Address";
                BillToAdressLine[3] := "Sales Invoice Header"."Bill-to Address 2";
                BillToAdressLine[4] := "Sales Invoice Header"."Bill-to City";
                BillToAdressLine[5] := "Sales Invoice Header"."Bill-to County";
                BillToAdressLine[6] := "Sales Invoice Header"."Bill-to Post Code";
                BillToAdressLine[7] := "Sales Invoice Header"."Bill-to Country/Region Code";

                ShipToAdressLine[1] := "Sales Invoice Header"."Ship-to Name";
                ShipToAdressLine[2] := "Sales Invoice Header"."Ship-to Name 2";
                ShipToAdressLine[3] := "Sales Invoice Header"."Ship-to Address";
                ShipToAdressLine[4] := "Sales Invoice Header"."Ship-to Address 2";
                ShipToAdressLine[5] := "Sales Invoice Header"."Ship-to City";
                ShipToAdressLine[6] := "Sales Invoice Header"."Ship-to County";
                ShipToAdressLine[7] := "Sales Invoice Header"."Ship-to Post Code";
                ShipToAdressLine[8] := "Sales Invoice Header"."Ship-to Country/Region Code";
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
                group(Options)
                {
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Internal Info';
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = All;
                        Caption = 'Log Interaction';
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

    trigger OnPreReport()
    begin
        CompanyInformationRec.Get();
        CompanyInformationRec.CalcFields(Picture);
        CompanyData[1] := CompanyInformationRec.Name;
        CompanyData[2] := CompanyInformationRec.Address;
        CompanyData[3] := CompanyInformationRec."VAT Registration No.";
        CompanyData[4] := CompanyInformationRec."Phone No.";

    end;

    var
        PostedSalesInvoiceRec: Record "Sales Invoice Header";
        CompanyInformationRec: Record "Company Information";
        VATSummary: Record "VAT Summary AS" temporary;
        BillToAdressLine: array[7] of Code[100];
        ShipToAdressLine: array[8] of Code[100];
        CompanyData: array[4] of Text;
        TotalExclVAT: Decimal;
        TotalInclVAT: Decimal;
        TotalVAT: Decimal;
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;

}