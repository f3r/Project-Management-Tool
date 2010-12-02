$(document).ready(function(){
	$(".generic").tablesorter();
	$(".generic tr").hover(
	  function () {
	    $(this).addClass("hover");
	  },
	  function () {
	    $(this).removeClass("hover");
	  }
	);
});

function update_tablesort(table) {
	$(table).tablesorter();
}