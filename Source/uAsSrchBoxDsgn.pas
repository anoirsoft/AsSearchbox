unit uAsSrchBoxDsgn;

interface

uses
  Classes, DesignIntf, DesignEditors, DBReg, System.TypInfo, Vcl.Dialogs , uAsSrchBox;



type

  TSearchItemFieldProperty = class(TDataFieldProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

procedure Register;

implementation

uses
  DB;

procedure TSearchItemFieldProperty.GetValueList(List: TStrings);
var
  Item: TSearchItem;
  ADataSet: TDataSet;

begin
   Item := GetComponent(0) as TSearchItem;

  ADataSet := TSearchItems(Item.Collection).SourceDATA;

  if (ADataSet <> nil) then
    ADataSet.GetFieldNames(List);

end;

procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string), TSearchItem, 'FieldName',
    TSearchItemFieldProperty);

end;




end.
