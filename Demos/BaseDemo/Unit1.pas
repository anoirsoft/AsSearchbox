unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uAsSrchBox, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Datasnap.Provider;

type
  TForm1 = class(TForm)
    AsSearchBox1: TAsSearchBox;
    Label1: TLabel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    ClientDataSet1CustNo: TFloatField;
    ClientDataSet1Company: TStringField;
    ClientDataSet1Addr1: TStringField;
    ClientDataSet1Addr2: TStringField;
    ClientDataSet1City: TStringField;
    ClientDataSet1State: TStringField;
    ClientDataSet1Zip: TStringField;
    ClientDataSet1Country: TStringField;
    ClientDataSet1Phone: TStringField;
    ClientDataSet1FAX: TStringField;
    ClientDataSet1TaxRate: TFloatField;
    ClientDataSet1Contact: TStringField;
    ClientDataSet1LastInvoiceDate: TDateTimeField;
    AsSearchBox2: TAsSearchBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ClientDataSet1.FileName := ParamStr(1)+'customer.cds';
  ClientDataSet1.Active := true;
end;

end.
