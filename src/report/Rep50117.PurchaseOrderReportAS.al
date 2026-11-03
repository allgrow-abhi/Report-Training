report 50117 "Purchase Order Report AS"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './PurchaseOrderReport.rdl';

    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            column(Purchase_Order_No; "No.") { }
            column(document_Date; "Document Date") { }
            column(Expected_Receipt_Date; "Expected Receipt Date") { }
            column(Buy_from_Vendor_No; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(BuyFromAddress1; BuyFromAddress[1]) { }
            column(BuyFromAddress2; BuyFromAddress[2]) { }
            column(BuyFromAddress3; BuyFromAddress[3]) { }
            column(BuyFromAddress4; BuyFromAddress[4]) { }
            column(BuyFromAddress5; BuyFromAddress[5]) { }
            column(BuyFromAddress6; BuyFromAddress[6]) { }
            column(BuyFromAddress7; BuyFromAddress[7]) { }
            column(BuyFromAddress8; BuyFromAddress[8]) { }
            column(currency_Code; "Currency Code") { }
            column(currency_Factor; "Currency Factor") { }
            column(CurrencyLabel; CurrencyLabel) { }
            column(TotalAmount; TotalAmount) { }
            column(TotalAmountLCY; TotalAmountLCY) { }
            column(AmountInWords; AmountInWords) { }
            column(ShowAmountInWords; ShowAmountInWords) { }

            dataitem(PurchaseLine; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"),
                                "Document No." = field("No.");
                column(Item_No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(Unit_of_Measure_Code; "Unit of Measure") { }
                column(Unit_Price; "Direct Unit Cost") { }
                column(Line_Amount; "Line Amount") { }
            }
            trigger OnPreDataItem()
            begin
                if PurchaseOrderNo <> '' then
                    SetRange("No.", PurchaseOrderNo);
            end;

            trigger OnAfterGetRecord()
            begin
                TotalAmount := 0;
                Clear(BuyFromAddress);
                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress, PurchaseHeader);

                PurchaseLine.Reset();
                PurchaseLine.SetRange("Document Type", "Document Type");
                PurchaseLine.SetRange("Document No.", "No.");

                if PurchaseLine.FindSet() then
                    repeat
                        TotalAmount += PurchaseLine."Line Amount";
                    until PurchaseLine.Next() = 0;

                GLSetup.Get();
                if "Currency Code" = '' then
                    CurrencyLabel := GLSetup."LCY Code"
                else
                    CurrencyLabel := "Currency Code";

                if "Currency Code" = '' then
                    TotalAmountLCY := TotalAmount
                else
                    TotalAmountLCY := TotalAmount * "Currency Factor";
                if ShowAmountInWords then
                    AmountInWords := AmountToWords(TotalAmountLCY);
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
                    field(PurchaseOrderNo; PurchaseOrderNo)
                    {
                        Caption = 'Purchase Order No.';
                        TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
                    }
                    field(ShowAmountInWords; ShowAmountInWords)
                    {
                        Caption = 'Show Amount in Words';
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
        formatAddress: Codeunit "Format Address";
        GLSetup: Record "General Ledger Setup";
        PurchCheckReport: Report "Check";
        BuyFromAddress: array[8] of Text[100];
        AmountInWords: Text[250];
        PurchaseOrderNo: Code[20];
        CurrencyLabel: Code[20];
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        ShowAmountInWords: Boolean;

    local procedure AmountToWords(Amount: Decimal): Text[250]
    var
        CheckTranslationManagement: Report "Check Translation Management";
        NoText: array[2] of Text[80];
    begin
        CheckTranslationManagement.FormatNoText(
            NoText,
            Amount,
            1033,
            CurrencyLabel);

        exit((NoText[1] + ' ' + NoText[2]));
    end;
}