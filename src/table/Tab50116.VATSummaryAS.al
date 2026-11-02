table 50116 "VAT Summary AS"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "VAT %"; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'VAT %';
        }
        field(2; "VAT Base"; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'VAT Base';
        }
        field(3; "VAT Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            caption = 'VAT Amount';
        }
    }

    keys
    {
        key(PK; "VAT %")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}