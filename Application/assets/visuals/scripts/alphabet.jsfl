var folder = "movekeys/alpahbet_";
var exportName = ["MovekeysChar", "1", "GraphicAssets"];
var name = "";
var dom = fl.getDocumentDOM();
var lib = dom.library;
var chars = ["А", "Б", "В", "Г",
	"Д", "Е", "Ж", "З",
	"И", "Й", "К", "Л",
	"М", "Н", "О", "П",
	"Р", "С", "Т", "У",
	"Ф", "Х", "Ц", "Ч",
	"Ш", "Щ", "Ъ", "Ы",
	"Ь", "Э", "Ю", "Я"
]

var backColor = '#323232';
var backSize = 70;
var backHalfSize = backSize * 0.5;

var borderSize = 1.5;
var borderColor = '#000000';

var backPoint = backSize - borderSize - 1;

var fontSize = 32;
var fontColor = "#f1f1f1";
var fontName = 'Lato-Regular'//'Lato-Thin';

var chrcr = "";
var index = 0;
for (var i = 0; i < chars.length; i++) {
	chrcr = chars[i];
	index = i + 1;
	name = String(folder + index)
	exportName[1] = String(index);
	fl.trace(i + ") " + chrcr + " | " + exportName.join(""));
	lib.addNewItem('movie clip', name);
	if (lib.getItemProperty('linkageImportForRS') == true) {
		lib.setItemProperty('linkageImportForRS', false);
	}
	lib.setItemProperty('linkageExportForAS', true);
	lib.setItemProperty('linkageExportForRS', false);
	lib.setItemProperty('linkageExportInFirstFrame', true);
	lib.setItemProperty('linkageClassName', exportName.join(""));

	lib.selectItem(name);
	lib.editItem();
	doc.addNewRectangle({
		left: 0,
		top: 0,
		right: backSize,
		bottom: backSize
	}, 0);

	doc.mouseClick({
		x: backHalfSize,
		y: backHalfSize
	}, false, false);
	doc.setFillColor(String(backColor));

	doc.mouseDblClk({
		x: 1,
		y: 1
	}, false, false, false);
	doc.setStrokeSize(borderSize);
	doc.setStrokeColor(borderColor);

	doc.selectNone();

	doc.addNewText({
		left: 0,
		top: 0,
		right: backSize,
		bottom: backSize
	});
	doc.setTextString(String(chrcr));
	doc.setElementTextAttr('size', fontSize);
	doc.setElementTextAttr('face', fontName);
	doc.setFillColor(fontColor);
	doc.arrange('front');

	doc.mouseDblClk({
		x: 1,
		y: 1
	}, true, true, true);
	doc.align('horizontal center', false);
	doc.align('vertical center', false);

	doc.selectNone();
	
	doc.mouseClick({
		x: backHalfSize,
		y: backHalfSize
	}, false, true);
	doc.breakApart();
}