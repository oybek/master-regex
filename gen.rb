#!/usr/bin/ruby

require 'json'

html = [
	"<html><style type='text/css'>body{background-color:#002b36;color: #839496;font-family:Ubuntu Mono,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace;}input{border: 0px;background-color:#073642;text-align: left;color: #839496;font-family:Ubuntu Mono,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace;width: 300px;}.main-block{display: table;margin: 0 auto;}.block{margin-top: 10px;margin-bottom: 10px;}.header{color: #93a1a1;font-weight: bold;}.normal{background-color:#002b36;color: #839496;font-family:Ubuntu Mono,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace;}.good-highlight{background-color:#002b36;font-weight: bold;color: #859900;font-family:Ubuntu Mono,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace;}.bad-highlight{background-color:#002b36;font-weight: bold;color: #dc322f;font-family:Ubuntu Mono,Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New,monospace;}</style><script src='https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js'></script><script>function changeClass(element, src, dst){if (element.className !=dst){element.removeClass(src);element.addClass(dst);}}function isGoodRgx(rgx, str){return rgx.test(str);}function checkGoodStrs(rgxPattern){matchn=0;goodStrNum=$('span[id^=\"good-str\"]').length;for (i=0; i < goodStrNum; ++i){curElement=$('#good-str'+i);if (isGoodRgx(rgxPattern, curElement.text())){changeClass(curElement, 'normal', 'good-highlight');matchn +=curElement.text().length;}else{changeClass(curElement, 'good-highlight', 'normal');}}return matchn;}function checkBadStrs(rgxPattern){matchn=0;badStrNum=$('span[id^=\"bad-str\"]').length;for (i=0; i < badStrNum; ++i){curElement=$('#bad-str'+i);if (isGoodRgx(rgxPattern, curElement.text())){changeClass(curElement, 'normal', 'bad-highlight');matchn +=curElement.text().length;}else{changeClass(curElement, 'bad-highlight', 'normal');}}return matchn;}",
	"",
	"function handleKeyup(){try{rgxPattern=new RegExp('^'+$('#user-input').val()+'$');}catch (e){return;}checkScore(rgxPattern,checkGoodStrs(rgxPattern),checkBadStrs(rgxPattern));}$(document).ready(function(){$('#user-input').keyup(handleKeyup);});</script><body><div class='main-block'><div class='block'><span>^</span><input type='text' id='user-input'/><span>$</span></div><hr noshade><div class='block'><span class='header'>Match:</span>",
	"",
	"</div><hr noshade><div class='block'><span class='header'>Don't match:</span>",
	"",
	"</div><hr noshade><div class='block'><span class='header'>Regex power: </span><span id='rgx-pow'>0</span></div></div></body></html>"
]

jsonObj = JSON.parse(File.read(ARGV[0]))

if	(jsonObj['gpow'] == nil) ||
	(jsonObj['rpow'] == nil) ||
	(jsonObj['ipow'] == nil)
	html[1] = sprintf(
		"function checkScore(rgx, goodn, badn){$('#rgx-pow').html(Math.max((%d*goodn-%d*badn-%d*rgx.source.length),0).toString());}",
		7, 1000, 3
	)
else
	html[1] = sprintf(
		"function checkScore(rgx, goodn, badn){$('#rgx-pow').html(Math.max((%d*goodn-%d*badn-%d*rgx.source.length),0).toString());}",
		jsonObj['gpow'].abs, jsonObj['rpow'].abs, jsonObj['ipow'].abs
	)
end

i = 0
jsonObj['good'].each { |x|
	html[3] += sprintf("<div><span id='good-str%d' class='normal'>%s</span></div>", i, x)
	i += 1
}

i = 0
jsonObj['bad'].each { |x|
	html[5] += sprintf("<div><span id='bad-str%d' class='normal'>%s</span></div>", i, x)
	i += 1
}

puts html.join('')

