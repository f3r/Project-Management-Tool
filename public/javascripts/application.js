$(document).ready(function(){
	$('a[rel=tooltip]').tipsy({fade: true, gravity: 's'});
	$('table.generic td.status').tipsy({fade: true, gravity: 'e'});
	$('table.timeReport input.nosign').tipsy({title: function() { return "Click to edit"; }, live: true, fade: true, gravity: 'e'});
	$('table.timeReport input.nosign').focus(function(){
		$(this).tipsy("hide");
	});

	$("a[rel=modal]").click(function(){
		new Boxy.load(this.href, {
				filter:this.hash,
				modal:true
			});
		return false;
	});

	$("a.button_delete").click(function(){
		$("a.button_delete + span.confirm").show();
		$(this).parent().addClass("selected");
		return false;
	});

	$("a.button_delete + span.confirm a.no").click(function(){
		$(this).parent().hide().parent().removeClass("selected");
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

	var clear_previous = '';
	$('.clear_on_focus').focus(function() {
		if($(this).val()==$(this).attr('title')) {
			clear_previous = $(this).val();
			$(this).val('');
		}
	});

	$('.clear_on_focus').blur(function() {
		if($(this).val()=='') {
			$(this).val(clear_previous);
		}
	});

	$('select.jump_menu').change(function() {
		window.location = this.value;
	});

});

function update_tablesort(table) {
	$(table).tablesorter();
}