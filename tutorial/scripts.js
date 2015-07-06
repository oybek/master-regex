
lvl = 0;
json = JSON.parse('{"lvl":[\
	{\
		"head" : "Regex basics",\
		"lecture" : "When you concentrace and think only about regex - you stuck",\
		"good" : ["can","man","fan"],"bad" : ["dan","ran","pan"]\
	},\
	{\
		"head" : "The end of young warrior path",\
		"lecture" : "Congratulations! You are now know a little bit more regex.",\
		"good" : [],"bad" : []\
	}\
]}');

function changeClass(element, src, dst) {
	if (element.className != dst) {
		element.removeClass(src);
		element.addClass(dst);
	}
}
function isGoodRgx(rgx, str) {
	return rgx.test(str);
}
function checkGoodStrs(rgxPattern) {
	matchn = 0;
	goodStrNum = $("span[id^='good-str']").length
	for (i = 0; i < goodStrNum; ++i) {
		curElement = $('#good-str'+i);
		if (isGoodRgx(rgxPattern, curElement.text())) {
			changeClass(curElement, 'normal', 'good-highlight');
			matchn += curElement.text().length;
		} else {
			changeClass(curElement, 'good-highlight', 'normal');
		}
	}
	return matchn;
}
function checkBadStrs(rgxPattern) {
	matchn = 0;
	badStrNum = $("span[id^='bad-str']").length
	for (i = 0; i < badStrNum; ++i) {
		curElement = $('#bad-str'+i);
		if (isGoodRgx(rgxPattern, curElement.text())) {
			changeClass(curElement, 'normal', 'bad-highlight');
			matchn += curElement.text().length;
		} else {
			changeClass(curElement, 'bad-highlight', 'normal');
		}
	}
	return matchn;
}
function checkScore(rgx, goodn, badn) {
	score = 7*goodn-1000*badn-3*rgx.source.length;
	$('#rgx-pow').html(Math.max(score, 0).toString());
	if (score > 0) {
		changeClass($('#bttn'), 'buttonoff', 'buttonon')
	} else {
		changeClass($('#bttn'), 'buttonon', 'buttonoff')
	}
}
function genGoodBlock(json) {
	tmp = '<span class="header">Match:</span>';
	for (i = 0; i < json['good'].length; ++i) {
		tmp += '<div><span id="good-str' + i + '" class="normal">' + json['good'][i] + '</span></div>';
	}
	$('#good-block').html(tmp);
}
function genBadBlock(json) {
	tmp = '<span class="header">Don\'t match:</span>';
	for (i = 0; i < json['bad'].length; ++i) {
		tmp += '<div><span id="bad-str' + i + '" class="normal">' + json['bad'][i] + '</span></div>';
	}
	$('#bad-block').html(tmp);
}
function loadLevel(lvlJson, i) {
	$('#rgx-pow').html('0');

	if (lvlJson[i]['head'] == null)
		$('#head').html('');
	else
		$('#head').html(lvlJson[i]['head']);

	if (lvlJson[i]['lecture'] == null)
		$('#lecture').html('');
	else
		$('#lecture').html(lvlJson[i]['lecture']);

	genGoodBlock(lvlJson[i]);
	genBadBlock(lvlJson[i]);
}
function handleKeyup() {
	try {
		rgxPattern = new RegExp('^(?:'+$('#user-input').val()+')$');
	} catch (e) {
		return;
	}
	checkScore(
		rgxPattern,
		checkGoodStrs(rgxPattern),
		checkBadStrs(rgxPattern)
	);
}
function handleButtonClick() {
	if ($('#bttn').hasClass('buttonon')) {
		++lvl;
		if (lvl < json['lvl'].length) {
			loadLevel(json['lvl'], lvl);
			if (lvl == json['lvl'].length-1) {
				$('#training-block').hide();
			}
		}
	}
}
$(document).ready(function() {
	$('#user-input').keyup(handleKeyup);
	$('#bttn').click(handleButtonClick);
	loadLevel(json['lvl'], lvl);
});
