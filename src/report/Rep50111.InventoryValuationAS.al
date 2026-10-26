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
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Item No." = field("No.");
                column(Location_Code; "Location Code") { }
                column(Item_Ledger_Entry_Quantity; "Item Ledger Entry Quantity") { }
                column(Cost_Amount__Actual_; "Cost Amount (Actual)") { }
            }
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
                    // field(Name; SourceExpression)
                    // {

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

    // rendering
    // {
    //     layout(LayoutName)
    //     {
    //         Type = Excel;
    //         LayoutFile = 'mySpreadsheet.xlsx';
    //     }
    // }

    var
        myInt: Integer;
}