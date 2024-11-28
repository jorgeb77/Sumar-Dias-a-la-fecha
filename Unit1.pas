unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.UITypes, Vcl.Menus, Vcl.StdCtrls,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxSchedulerStorage, cxSchedulerCustomControls, cxSchedulerDateNavigator,
  cxButtons, cxContainer, cxDateNavigator, cxEdit, cxCheckBox, cxLabel,
  cxTextEdit, cxMaskEdit, cxSpinEdit;

type
  TForm1 = class(TForm)
    cxButton1: TcxButton;
    CheckBoxExcluirFines: TcxCheckBox;
    EdCantDias: TcxSpinEdit;
    cxLabel1: TcxLabel;
    cxButton2: TcxButton;
    cxLabel2: TcxLabel;
    CkbIncluirSabado: TcxCheckBox;
    CkbIncluirDomingo: TcxCheckBox;
    cxDateNavigator1: TcxDateNavigator;
    procedure cxButton1Click(Sender: TObject);
    procedure cxButton2Click(Sender: TObject);
    procedure EdCantDiasPropertiesChange(Sender: TObject);
  private
    function SumarDias(FechaInicial : TDate; DiasASumar : Integer; ExcluirFinesDeSemana : Boolean) : TDate; overload;
    function SumarDias(FechaInicial : TDate; DiasASumar : Integer; IncluirSabado, IncluirDomingo : Boolean) : TDate; overload;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.cxButton1Click(Sender: TObject);
var
  FechaSeleccionada, FechaFinal : TDate;
  Dias : Integer;
  ExcluirFinesDeSemana : Boolean;
begin
  if EdCantDias.Value = 0 then
    begin
      MessageDlg('La cantidad de dias debe ser mayor a cero.' +#13+
                 'Por favor verifique', TMsgDlgType.mtWarning, [mbOK], 0);
      Exit;
    end;

  FechaSeleccionada    := cxDateNavigator1.Date; // Supongamos que Calendar1 es tu componente de calendario
  Dias                 := EdCantDias.Value; // Cantidad de días a sumar
  ExcluirFinesDeSemana := CheckBoxExcluirFines.Checked; // Excluir fines de semana (True para excluir sábados y domingos, False para incluirlos).
  FechaFinal := SumarDias(FechaSeleccionada, Dias, ExcluirFinesDeSemana);
  MessageDlg('La fecha final es : ' + DateToStr(FechaFinal), TMsgDlgType.mtInformation, [mbOK], 0);
end;


procedure TForm1.cxButton2Click(Sender: TObject);
var
  FechaSeleccionada, FechaFinal : TDate;
  Dias : Integer;
  IncluirSabado, IncluirDomingo : Boolean;
begin
  if EdCantDias.Value = 0 then
    begin
      MessageDlg('La cantidad de dias debe ser mayor a cero.' +#13+
                 'Por favor verifique', TMsgDlgType.mtWarning, [mbOK], 0);
      Exit;
    end;

  FechaSeleccionada := cxDateNavigator1.Date; // Tu componente de calendario
  Dias              := EdCantDias.Value; // Cantidad de días a sumar
  IncluirSabado     := CkbIncluirSabado.Checked; // Checkbox para incluir o excluir sábado
  IncluirDomingo    := CkbIncluirDomingo.Checked; // Checkbox para incluir o excluir domingo
  FechaFinal := SumarDias(FechaSeleccionada, Dias, IncluirSabado, IncluirDomingo);
  MessageDlg('La fecha final es : ' + DateToStr(FechaFinal), TMsgDlgType.mtInformation, [mbOK], 0);
end;

procedure TForm1.EdCantDiasPropertiesChange(Sender: TObject);
begin
  if EdCantDias.Value < 0 then    //Evitamos los numeros negativos
    begin
      EdCantDias.Value    := 0;
      EdCantDias.SelStart := Length(EdCantDias.Text);
    end;
end;

function TForm1.SumarDias(FechaInicial : TDate; DiasASumar : Integer; ExcluirFinesDeSemana : Boolean) : TDate;
var
  DiasSumados : Integer;
begin
  Result      := FechaInicial;
  DiasSumados := 0;
  // Sumamos días hasta alcanzar la cantidad deseada
  while DiasSumados < DiasASumar do
    begin
      // Avanza un día
      Result := Result + 1;
      // Si no se excluyen los fines de semana o el día no es sábado/domingo, cuenta como día válido
      if not ExcluirFinesDeSemana or ((DayOfWeek(Result) <> 7) and (DayOfWeek(Result) <> 1)) then
        Inc(DiasSumados);
    end;
end;

//CON ESTA VARIACION MANEJAMOS LOS FINES DE SEMANA POR SEPARADO
function TForm1.SumarDias(FechaInicial : TDate; DiasASumar : Integer; IncluirSabado, IncluirDomingo : Boolean) : TDate;
var
  DiasSumados : Integer;
  DiaDeLaSemana : Integer;  //DiaDeLaSemana: Usado para verificar si el día actual es sábado (7) o domingo (1).
begin
  Result      := FechaInicial;
  DiasSumados := 0;
  // Sumamos días hasta alcanzar la cantidad deseada
  while DiasSumados < DiasASumar do
    begin
      // Avanza un día
      Result := Result + 1;
      DiaDeLaSemana := DayOfWeek(Result);
      { Si el día es sábado y no se incluye, o es domingo y no se incluye, no contar
        El comando Continue permite omitir el resto del código dentro del bucle y pasar directamente a la siguiente iteración. }
      if ((DiaDeLaSemana = 7) and not IncluirSabado) or ((DiaDeLaSemana = 1) and not IncluirDomingo) then
        Continue;
      // Si pasa las condiciones, cuenta como día válido
      Inc(DiasSumados);
    end;
end;


end.
