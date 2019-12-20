{ *************************************************** }
{       TAsSearchBox component                        }
{       written by HADJI BOULANOUAR (Anoirsoft)       }
{                                                     }
{       Email : anoirsoft.com@gmail.com               }
{       Web : http://www.anoirsoft.com                }
{                                                     }
{ *************************************************** }
unit uAsSrchBoxDsgn;

interface

uses
  Classes, DesignIntf, DesignEditors, DBReg, System.TypInfo, Vcl.Dialogs , uAsSrchBox;



type

  TSearchItemFieldProperty = class(TDataFieldProperty)
  public
    procedure GetValueList(List: TStrings); override;
  end;

  TAsSearchBoxEditor=class(TComponentEditor)
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
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
  RegisterComponentEditor(TAsSearchBox, TAsSearchBoxEditor);
end;


{ TAsSearchBoxEditor }

procedure TAsSearchBoxEditor.ExecuteVerb(Index: Integer);
begin
  inherited;
   case Index of
    0: (Component as TAsSearchBox).RetrieveALLFields;
    1: ShowMessage('TAsSearchBox component'#10#13+
    'written by HADJI BOULANOUAR (Anoirsoft)'#10#13+'Email : anoirsoft.com@gmail.com'#10#13+'Web : http://www.anoirsoft.com' );
  end;
end;

function TAsSearchBoxEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := '&Retrieve all fields';
    1: Result := '&About';

  end;
end;

function TAsSearchBoxEditor.GetVerbCount: Integer;
begin
   Result := 2;
end;


end.
