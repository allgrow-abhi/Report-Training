report 50111 "Inventory Valuation AS"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'InventoryValuation.rdl';
    Caption = 'Inventory Valuation AS';

    dataset
    {
        dataitem(Item; Item)
        {
            column(ItemNo; "No.") { }
            column(ItemDescription; Description) { }
            column(Item_Category_Code; "Item Category Code") { }
            column(ItemCategoryName; ItemCategoryName) { }
            column(UnitCost; UnitCost) { }
            column(AsOfDate; ValuationDate) { }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = field("No.");
                column(Location_Code; "Location Code") { }
                column(Quantity; "Item Ledger Entry Quantity") { }
                column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
                column(LocationName; LocationName) { }
                trigger OnPreDataItem()
                begin
                    if Format(ValuationDate) <> '' then begin
                        SetFilter("Posting Date", '..%1', ValuationDate);
                    end;

                    if LocationCode <> '' then begin
                        SetRange("Location Code", LocationCode);
                    end;
                end;

                trigger OnAfterGetRecord()
                begin
                    if LocationCategoryRec.Get(LocationCategoryRec.Code) then begin
                        LocationName := LocationCategoryRec.Name;
                    end;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                if "Value Entry"."Item Ledger Entry Quantity" <> 0 then begin
                    UnitCost := "Value Entry"."Cost Amount (Actual)" / "Value Entry"."Item Ledger Entry Quantity";
                end;

                if ItemCategoryRec.Get(ItemCategoryRec.Code) then begin
                    ItemCategoryName := ItemCategoryRec.Description;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ItemCategoryCode <> '' then begin
                    SetRange("Item Category Code", ItemCategoryCode);
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
                    field(ValuationDate; ValuationDate)
                    {
                        Caption = 'Valuation Date';
                        ApplicationArea = all;
                    }
                    field(ItemCategoryCode; ItemCategoryCode)
                    {
                        Caption = 'Item Category Code';
                        ApplicationArea = all;
                        TableRelation = "Item Category".Code;
                    }
                    field(LocationCode; LocationCode)
                    {
                        Caption = 'Location Code';
                        ApplicationArea = all;
                        TableRelation = Location.Code;
                    }

                    group(Option)
                    {
                        field(PageBreak; PageBreak)
                        {
                            Caption = 'Page Break';
                            ApplicationArea = all;
                        }
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
        UnitCost: Decimal;
        ValuationDate: Date;
        ItemCategoryCode: Code[50];
        LocationCode: Code[50];
        PageBreak: Boolean;
        ItemCategoryRec: Record "Item Category";
        LocationCategoryRec: Record Location;
        ItemCategoryName: Text[100];
        LocationName: Text[100];
}