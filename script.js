var someList=[];
// test
$(document).ready(function() {

    $('#test-button').click(function() {
      
	// Need to alert - Security/CWE-079/XssThroughDom.ql
	var text = document.getElementById("user-text").value;
    	document.getElementById("user-input-results").innerHTML = text;
	document.getElementById("user-input-results").innerHTML = text;
	document.getElementById("user-input-results").innerHTML = text;
      
	$.ajax({
		type: 'GET',
		url: 'php/search.php',
		data: {
		  search_keyword: text
		},
		success: function(returnData) {
	  		$('#search_results').html('');

	  		var rawResults = JSON.parse(returnData);
	  		var displayedResults = Object.values(rawResults[0]);

	  		if(displayedResults.length == 0){
	    		$('#search-results').html('No results found!');
	  		}
	  		else {
	    		$('#search-results').empty();
	    		loadSomeRecords(displayedResults, 'search-results');
	  		}
		}
	});
    });
});

function f() {
    x = 23;
    let x;
}

function loadSomeRecords(someList, element) {
	if(someList) {
		var someDisplayedList = document.getElementById(element);
		var nextRecords = someDisplayedList.innerHTML;

		// Alert - Declarations/UnusedVariable.ql
		//var size = 1 + 1;

		someList.forEach(item => {
			nextRecords += `<li><a href="#" onclick="logResults('${item}');">${item}</a></li>`
		})

		someDisplayedList.innerHTML = nextRecords;
	}
}

function logResults(name) {
  eval("console.log('This is a result: ' + name)");
}

function something(name) {
  eval("console.log('This is a result: ' + name)");
}

