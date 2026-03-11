' Test_WebView4Delphi_dll.bas

constantes()
labels()
variables()
GUI()
initialisations()
end


sub constantes()
  dim WebView$ : WebView$ = "DllBrowser.dll"
end_sub

sub labels()
  label close0, CreerWB, SVT, shiftHorz, shiftVert, zoomHorz, zoomVert
end_sub

sub variables()
  dim res%, WB%, fic$, URL$, script$, p%
end_sub

sub GUI()           
  full_space 0
  on_close 0,Close0 
  caption 0,str$(handle(0))+"   "+str$(object_internal(0))
  button 1 : top 1,10 : left 1,10 : caption 1,"Créer" : on_click 1,CreerWB
  button 2 : top 2,10 : left 2,120 : caption 2,"Fichier SVT" : on_click 2,SVT
  list 10 : top 10,40 : left 10,690 : width 10,200 : height 10,300
  scroll_bar 20 : top 20,690 : left 20,10 : width 20,620
    min 20,0 : max 20,40000 : position 20,0 : on_change 20,shiftHorz 
  scroll_bar 21 : top 21,40 : left 21,630 : vertical 21 : height 21,650
    min 21,0 : max 21,275 : position 21,0 : on_change 21,ShiftVert
  open_dialog 100  
  panel 50 : top 50,500 : left 50,690 : width 50,300 : height 50,150 
  alpha 51 : parent 51,50 : top 51,20 : left 51,20 : caption 51,"Zoom 1000"
  alpha 52 : parent 52,50 : top 52,60 : left 52,20 : caption 52,"Horizontal:"
  alpha 53 : parent 53,50 : top 53,90 : left 53,20 : caption 53,"Vertical:"
  scroll_bar 54 : parent 54,50 : top 54,60 : left 54,100 : width 54,180
    min 54,0 : max 54,4000 : position 54,1000 :  on_change 54,zoomHorz 
  scroll_bar 55 : parent 55,50 : top 55,90 : left 55,100 : width 55,180
    min 55,0 : max 55,400 : position 55,275 :  on_change 55,zoomVert 
  
end_sub

sub initialisations()
  dll_on WebView$         
end_sub

Close0:
  res% = dll_call0("FinalizeWebView4Delphi")
  dll_off
  return
  
CreerWB:
  if WB%<>0
    message "WB est déjà créé"
    return
  end_if
  res% = dll_call0("InitializeWebView4Delphi")
  WB% = dll_call6("ShowBrowser",Handle(0),1,  10,40,620,650)
  if WB%=0 then message "Erreur en création de WB"
  return

SVT:
  fic$ = file_name$(100)
  if fic$="_" then return
  
  URL$ = "File:///" + fic$
  res% = dll_call2("BrowserNavigate",WB%,adr(URL$))
  
  res% = dll_call4("SetBrowserMessageCommunication",WB%,1, 0,handle(10))
  res% = dll_call2("SetBrowserScrollBars",WB%,0)

  return
  
shiftHorz:
  script$ = "ShiftHorz("+str$(Position(20))+")"
  res% = dll_call2("ExecuteBrowserScript",WB%,adr(script$))  
  return
  
shiftVert:
  script$ = "ShiftVert("+str$(Position(21))+")"
  res% = dll_call2("ExecuteBrowserScript",WB%,adr(script$))  
  return

zoomHorz:
  script$ = "ZoomHorz("+str$(Position(54))+")"
  p% = Position(54)
  Caption 51,"Zoom "+format$(1000/p%)
  res% = dll_call2("ExecuteBrowserScript",WB%,adr(script$))  
  return
  
zoomVert:
  script$ = "ZoomVert("+str$(Position(55))+")"
  res% = dll_call2("ExecuteBrowserScript",WB%,adr(script$))  
  return
  
fnc format$(v)
  dim_local sf$, n%, m%
  sf$ = str$(v)
  n% = instr(sf$,".")
  if n%>0
    m% = len(sf$)
    if m%>(n%+3) then m% = n% + 3
    sf$ = left$(sf$,m%)
  end_if 
  result sf$
end_fnc
         

