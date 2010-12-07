$(document).ready(function(){
	$('a[rel=tipsy]').tipsy({fade: true, gravity: 's'});
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