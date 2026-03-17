var xClick = 0;
var yClick = 0;
var col = 0;
var row = 0;
var BaseX = 0;
var BaseY = 0;
var CellWidth = 100;
var RowHeight = 25;
var ZoomFact = 1;

function num(x) {
  if (isNaN(x)) {
    return 0;
  }
  return x;
}

document.addEventListener('click', function(event) {
    const x = event.clientX
    const y = event.clientY
	if (document.getElementById("ZoomFactor").Value === undefined) { 
           document.getElementById("ZoomFactor").Value = 1000;
    }	
  	let  fact = 1000 / document.getElementById("ZoomFactor").Value;
	fact = num(fact);
//    let BaseX = ~~ BaseX;
//    let BaseY = ~~ BaseY;
//    BaseX = (BaseX === 0) ? BaseX : 0;
//    BaseY = (BaseY === 0) ? BaseY : 0;
//    BaseX = BaseX ? BaseX : 0;
//    BaseY = BaseY ? BaseY : 0;
//    BaseX = SanitizeNan(BaseX)
//    BaseY = SanitizeNan(BaseY)
//    BaseX = num(BaseX);
//    BaseY = num(BaseY);

    xClick = BaseX*fact + x - 8;
	yClick = BaseY*fact + y - 8;
    col = Math.trunc((xClick+99*fact)/(100*fact))-1;
    row = Math.trunc((yClick+24*fact)/(25*fact))-1;	
	document.getElementById("msgtext").Value = xClick+","+yClick+"/"+col+","+row+"/"+fact;
	sendMessageToHostApp();
})

function sendMessageToHostApp() {
	let data = document.getElementById("msgtext").Value;
    window.chrome.webview.postMessage(data);
}

function ShiftRight(){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.x = vBox.baseVal.x + 800;
	BaseX = vBox.baseVal.x;
}
 
 function ShiftLeft(){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.x = vBox.baseVal.x - 800;
	BaseX = vBox.baseVal.x;
}

function ShiftDown(){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.y = vBox.baseVal.y + 25*5;
	BaseY = vBox.baseVal.y;
}

function ShiftHorz(p){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.x = p;
	BaseX = p;
}

function ShiftVert(p){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.y = p;
	BaseY = p;
}

function ShiftHome(){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.x = 0;
	vBox.baseVal.y = 0;
	BaseX = 0;
	BaseY = 0;
}

function ZoomHorz(p){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.width = p;
	document.getElementById("ZoomFactor").Value  = p;
}

function ZoomVert(p){
	const svg = document.querySelector("svg");
    const vBox = svg.viewBox;
	vBox.baseVal.height = p;
}




