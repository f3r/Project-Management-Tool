$(document).ready(function(){
	$('a[rel=tooltip]').tipsy({fade: true, gravity: 's'});

	$("a[rel=modal]").click(function(){
		new Boxy.load(this.href, {
				filter:this.hash,
				modal:true
			});
		return false;
	});

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