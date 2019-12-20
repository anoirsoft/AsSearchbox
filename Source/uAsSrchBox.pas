{ *************************************************** }
{       TAsSearchBox component                        }
{       written by HADJI BOULANOUAR (Anoirsoft)       }
{                                                     }
{       Email : anoirsoft.com@gmail.com               }
{       Web : http://www.anoirsoft.com                }
{                                                     }
{ *************************************************** }
unit uAsSrchBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, DB,
  Vcl.Dialogs, System.UITypes;

type
  TLogicalOperators = (loAND, loOR);
  TRelationalOperators = (roContains, roEqualTo, roNotEqualTo, roLessThan,
    roLessThanOrEqualTo, roGreaterThan, roGreaterThanOrEqualTo, roStartWith,
    roEndsWith);

  TSearchPredFilter = Class(TPersistent)
  private
    FActive: Boolean;
    FFilter: String;
  public
    procedure Assign(Other: TPersistent); override;
  published
    property Active: Boolean read FActive write FActive default false;
    property Filter: String read FFilter write FFilter;
  End;

  TSearchOptions = Class(TPersistent)
  private
    FCaseSensitive: Boolean;
    FSearchPredFilter: TSearchPredFilter;
    procedure SetSearchPredFilter(const Value: TSearchPredFilter);
  public
    procedure Assign(Other: TPersistent); override;
    Constructor Create;
    destructor Destroy; override;
  published
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive
      default false;
    Property SearchPredFilter: TSearchPredFilter read FSearchPredFilter
      write SetSearchPredFilter;

  End;

  TSearchItemOptions = Class(TPersistent)
  private
    FRelationalOperator: TRelationalOperators;
    FLogicalOperator: TLogicalOperators;
    FCustomValueInput: String;
    FUseQuotedStr: Boolean;
    procedure SetLogicalOperator(const Value: TLogicalOperators);

  public
    procedure Assign(Other: TPersistent); override;
  published
    property LogicalOperator: TLogicalOperators read FLogicalOperator
      write SetLogicalOperator default loOR;
    property RelationalOperator: TRelationalOperators read FRelationalOperator
      write FRelationalOperator default roContains;
    property UseQuotedStr: Boolean Read FUseQuotedStr write FUseQuotedStr;
    property CustomValueInput: String read FCustomValueInput
      write FCustomValueInput;

  End;

  TSearchItem = Class(TCollectionItem)
  private
    FFieldName: String;
    FCaption: string;
    FEnabled: Boolean;
    FSearchItemOptions: TSearchItemOptions;
    FTag: LongInt;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    function GetDisplayName: string; override;
  Published
    property FieldName: String Read FFieldName write FFieldName;
    Property Caption: string Read FCaption write FCaption;
    Property Enabled: Boolean Read FEnabled write FEnabled;
    Property Options: TSearchItemOptions read FSearchItemOptions
      write FSearchItemOptions;
    Property Tag: LongInt read FTag write FTag default 0;

  End;

  TSearchItems = class(TOwnedCollection)
  private
    FSourceDATA: TDataSet;
    function GetItem(Index: Integer): TSearchItem;
    procedure SetItem(Index: Integer; const Value: TSearchItem);
  public
    function Add: TSearchItem;
    property Item[Index: Integer]: TSearchItem read GetItem
      write SetItem; default;
    property SourceDATA: TDataSet read FSourceDATA;
  end;

  TAsSearchBox = class(TEdit)
  private
    FdataSet: TDataSet;
    FSrchFldList: TSearchItems;
    FNormalColor: TColor;
    FColorFound: TColor;
    FColorNotFound: TColor;
    FsearchOptions: TSearchOptions;
    FSearchActive: Boolean;

    procedure Setdataset(const Value: TDataSet);
    function LoadFilter(AValue: string): WideString;
    function GetFldList: TSearchItems;
    function GetFilterItem(AField: String;
      RelationalOperator: TRelationalOperators; AInputValue: String;
      UseQuotedStr: Boolean): String;
    procedure SetFldList(const Value: TSearchItems);

    { Private declarations }
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    { Protected declarations }
  public
    Procedure Change; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    Procedure RetrieveALLFields;
    procedure AddSearchItem(AField: string; ACaption: string = '';
      ALogicalOperator: TLogicalOperators = loOR;
      ARelationalOperator: TRelationalOperators = roContains;
      ACustomValueInput: string = ''; IsEnabled: Boolean = True;
      AUseQuotedStr: Boolean = false);
    { Public declarations }
  published
    property SearchActive: Boolean read FSearchActive Write FSearchActive
      default True;
    property SearchDataSet: TDataSet read FdataSet Write Setdataset;
    property SearchItems: TSearchItems read GetFldList Write SetFldList;
    property SearchColor: TColor read FNormalColor Write FNormalColor;
    property SearchColorFound: TColor read FColorFound Write FColorFound;
    property SearchColorNotFound: TColor read FColorNotFound
      Write FColorNotFound;

    Property SearchOptions: TSearchOptions read FsearchOptions
      write FsearchOptions;

    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Anoirsoft', [TAsSearchBox]);
end;

{ TAsSearchBox }

procedure TAsSearchBox.AddSearchItem(AField: string; ACaption: string = '';
  ALogicalOperator: TLogicalOperators = loOR;
  ARelationalOperator: TRelationalOperators = roContains;
  ACustomValueInput: string = ''; IsEnabled: Boolean = True;
  AUseQuotedStr: Boolean = false);
var
  AItem: TSearchItem;
begin
  if Assigned(FdataSet) and (FdataSet.FieldCount <> 0) then
  begin
    AItem := TSearchItem.Create(FSrchFldList);
    with AItem, Options do
    begin
      Caption := ACaption;
      FieldName := AField;
      FEnabled := IsEnabled;
      RelationalOperator := ARelationalOperator;
      LogicalOperator := ALogicalOperator;
      CustomValueInput := ACustomValueInput;
      UseQuotedStr := AUseQuotedStr;
    end;
  end;
end;

procedure TAsSearchBox.Change;
begin
  inherited;
  if Assigned(FdataSet) and FdataSet.Active and (LoadFilter(Self.Text) <> '')
    and (FSearchActive) then
  begin
    with FdataSet do
    begin
      Filtered := false;
      if Self.GetTextLen <> 0 then
      begin
        try
          if not FsearchOptions.FCaseSensitive then
            FilterOptions := [foCaseInsensitive];

          if FsearchOptions.FSearchPredFilter.FActive then
            Filter := '(' + FsearchOptions.FSearchPredFilter.FFilter + ') and ('
              + LoadFilter(Self.Text) + ')'
          else
            Filter := LoadFilter(Self.Text);

          Filtered := True;

          if not(IsEmpty) then
            Color := FColorFound
          else
            Color := FColorNotFound;
        except
          Color := FColorNotFound;
        end;

      end
      else
      begin
        FdataSet.Filtered := false;
        Color := FNormalColor;
      end;
    end;
  end;
end;

constructor TAsSearchBox.Create(AOwner: TComponent);
begin
  inherited;

  SearchActive := True;
  FSrchFldList := TSearchItems.Create(AOwner, TSearchItem);
  FsearchOptions := TSearchOptions.Create;

  FNormalColor := Color;
  FColorFound := $00BFFFBF;
  FColorNotFound := $00D7D7FF;

  with Font do
  begin
    Name := 'Segoe UI';
    Size := 10;
  end;

end;

destructor TAsSearchBox.Destroy;
begin
  inherited;
  FreeAndNil(FSrchFldList);
  FreeAndNil(FsearchOptions);
end;

function TAsSearchBox.GetFilterItem(AField: String;
  RelationalOperator: TRelationalOperators; AInputValue: String;
  UseQuotedStr: Boolean): String;
var
  TmpOper: string;
begin
  if RelationalOperator in [roContains, roStartWith, roEndsWith] then
  begin
    case RelationalOperator of
      roContains:
        Result := '(' + AField + ' Like ' +
          QuotedStr('%' + AInputValue + '%') + ' )';
      roStartWith:
        Result := '(' + AField + ' Like ' + QuotedStr(AInputValue + '%') + ' )';
      roEndsWith:
        Result := '(' + AField + ' Like ' + QuotedStr('%' + AInputValue) + ' )';
    end;
  end
  else
  begin
    case RelationalOperator of
      roEqualTo:
        TmpOper := '=';
      roNotEqualTo:
        TmpOper := '<>';
      roLessThan:
        TmpOper := '<';
      roLessThanOrEqualTo:
        TmpOper := '<=';
      roGreaterThan:
        TmpOper := '>';
      roGreaterThanOrEqualTo:
        TmpOper := '>=';
    end;
    case UseQuotedStr of
      True:
        Result := '(' + AField + TmpOper + QuotedStr(AInputValue) + ' )';
      false:
        Result := '(' + AField + TmpOper + AInputValue + ')';
    end;
  end;
end;

function TAsSearchBox.GetFldList: TSearchItems;
begin
  Result := FSrchFldList;
  Result.FSourceDATA := FdataSet;
end;

procedure TAsSearchBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if not(Assigned(FdataSet)) then
    Exit;
  case Ord(Key) of
    vkUp:
      FdataSet.Prior;
    vkDown:
      FdataSet.Next;
  end;
end;

function TAsSearchBox.LoadFilter(AValue: string): WideString;
var
  i, tmp: SmallInt;
  TmpList: TStringList;

begin
  TmpList := TStringList.Create;
  try
    if FSrchFldList.Count = 0 then
      Exit;

    if FSrchFldList.Count > 0 then
    begin
      tmp := 0;
      for i := 0 to FSrchFldList.Count - 1 do
      begin
        with FSrchFldList[i], Options do
        begin
          if Enabled = True then
          begin
            tmp := tmp + 1;

            if tmp = 1 then
            begin
              if CustomValueInput = '' then
                TmpList.Add(GetFilterItem(FieldName, RelationalOperator, AValue,
                  UseQuotedStr))
              else
                TmpList.Add(GetFilterItem(FieldName, RelationalOperator,
                  CustomValueInput, UseQuotedStr));

            end
            else if tmp > 1 then
            begin
              case Options.FLogicalOperator of
                loAND:
                  TmpList.Add(' And ');
                loOR:
                  TmpList.Add(' Or ');
              end;
              if CustomValueInput = '' then
                TmpList.Add(GetFilterItem(FieldName, RelationalOperator, AValue,
                  UseQuotedStr))
              else
                TmpList.Add(GetFilterItem(FieldName, RelationalOperator,
                  CustomValueInput, UseQuotedStr));
            end;

          end;

        end;

      end;

    end;

    Result := TmpList.Text;
  finally
    TmpList.Free;
  end;
end;

procedure TAsSearchBox.RetrieveALLFields;
var
  i, msg_rslt: Integer;
  ASearchItem: TSearchItem;
begin
  if not(Assigned(FdataSet)) then
  begin
    raise Exception.Create('SearchDataSet not assigned');
    Exit;
  end;

  if Assigned(FdataSet) and (FdataSet.FieldCount <> 0) then
  begin
    with FdataSet, ASearchItem do
    begin
      if FSrchFldList.Count > 0 then
        msg_rslt :=
          MessageDlg('Do you want to Clear SearchItems before retrieving " ' +
          FdataSet.Name + ' " Fields ? ', mtConfirmation, mbYesNoCancel, 0)
      else
        msg_rslt := mrNo;

      if msg_rslt = mryes then
        FSrchFldList.Clear;

      if msg_rslt in [mryes, mrNo] then
      begin
        for i := 0 to FdataSet.FieldCount - 1 do
        begin
          ASearchItem := TSearchItem.Create(FSrchFldList);

          Caption := Fields[i].FieldName;
          FieldName := Fields[i].FieldName;
        end;
        MessageDlg('Done !', mtInformation, [mbOK], 0);
      end;
    end;
  end;
end;

procedure TAsSearchBox.Setdataset(const Value: TDataSet);
begin
  FdataSet := Value;
end;

procedure TAsSearchBox.SetFldList(const Value: TSearchItems);
begin
  FSrchFldList.Assign(Value);
end;

{ TSearchItems }

function TSearchItems.Add: TSearchItem;
begin
  Result := inherited Add as TSearchItem;
end;

function TSearchItems.GetItem(Index: Integer): TSearchItem;
begin
  Result := inherited Items[Index] as TSearchItem;
end;

procedure TSearchItems.SetItem(Index: Integer; const Value: TSearchItem);
begin
  inherited SetItem(Index, Value);
end;

{ TSearchOptions }

procedure TSearchOptions.Assign(Other: TPersistent);
begin
  if Other is TSearchOptions then
  begin
    FCaseSensitive := TSearchOptions(Other).FCaseSensitive;
    FSearchPredFilter.Assign((Other as TSearchOptions).SearchPredFilter);
  end
  else
    inherited
end;

constructor TSearchOptions.Create;
begin
  inherited Create;
  FSearchPredFilter := TSearchPredFilter.Create;
end;

destructor TSearchOptions.Destroy;
begin
  FSearchPredFilter.Free;
  inherited;
end;

procedure TSearchOptions.SetSearchPredFilter(const Value: TSearchPredFilter);
begin
  FSearchPredFilter.Assign(Value);
end;

{ TSearchItem }

constructor TSearchItem.Create(Collection: TCollection);
begin
  inherited;
  FSearchItemOptions := TSearchItemOptions.Create;
  FSearchItemOptions.FRelationalOperator := roContains;
  FSearchItemOptions.FLogicalOperator := loOR;
  Tag := 0;
end;

destructor TSearchItem.Destroy;
begin
  inherited;
  FreeAndNil(FSearchItemOptions);
end;

function TSearchItem.GetDisplayName: string;
begin
  if Caption <> '' then
  begin
    Result := Caption;
  end
  else
  begin
    if FieldName <> '' then
      Result := FFieldName
    else
      Result := '<Empty>';
  end;
end;

{ TSearchItemOptions }

procedure TSearchItemOptions.Assign(Other: TPersistent);
begin
  if Other is TSearchItemOptions then
  begin
    FRelationalOperator := TSearchItemOptions(Other).FRelationalOperator;
    FLogicalOperator := TSearchItemOptions(Other).FLogicalOperator;
    FCustomValueInput := TSearchItemOptions(Other).FCustomValueInput;
    FUseQuotedStr := TSearchItemOptions(Other).FUseQuotedStr;
  end
  else
    inherited
end;

procedure TSearchItemOptions.SetLogicalOperator(const Value: TLogicalOperators);
begin
  FLogicalOperator := Value;
end;

{ TSearchPredFilter }

procedure TSearchPredFilter.Assign(Other: TPersistent);
begin

  if Other is TSearchPredFilter then
  begin
    FActive := TSearchPredFilter(Other).FActive;
    FFilter := TSearchPredFilter(Other).FFilter;
  end
  else
    inherited

end;

end.
