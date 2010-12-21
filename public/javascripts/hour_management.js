
error = false;

$('.hours').focusin(function() {
   last_value = $(this).val();
});

$('.hours').click(function() {
  if ((this.value == 0) && ($(this).hasClass('nosign'))) {
    $(this).val("");
  }
});

//
// All the logic for Hours that can be edited
//
$('.hours').focusout(function() {

	$("a.button_save_report").html("Save Report").removeClass("active");

  // If user leaves blank, we put a zero
  if (this.value == "") {
    $(this).val("0");
    return false;
  }
  // We help the user to change "," for "."
  if (this.value.indexOf(",") != -1) {
    this.value = this.value.replace(",",".");
  }
  // if user doesn't write a number
  if (isNaN(this.value) || isNaN(parseFloat(this.value))) {
    error = true;
    $(this).val(last_value);
    alert('Please introduce a valid number!');
    $(this).focus();
  }
  
  // we check that there has been no error
  if (!error) {
    project_id = this.id.split("_")[0].substr(1)
    job_id     = this.id.split("_")[1].substr(1)
    week_day   = this.id.split("_")[2]
    hours      = this.value
    
    // Update Job TOTAL
    total = 0
    for(i=1;i<6;i++) {
      total += parseFloat($("#p"+project_id+"_j"+job_id+"_"+i).val());
    }
    $("#p"+project_id+"_j"+job_id+"_total").html(total);
    
    // Update Project ALL JOBS OF DAY 
    total = 0
    $('input[id^="p'+project_id +'_j"][id$='+week_day+']').each(function() {
      total += parseFloat($(this).val());
    });
    $("#pr"+project_id+"_"+week_day).html(total);
      
    // Update Project WEEK TOTAL
    total = 0
    for(i=1;i<6;i++) {
      total += parseFloat($("#pr"+project_id+"_"+i).html());
    }
    $("#pr"+project_id+"_total").html(total);
    
    // Update Day TOTAL
    total = 0
    $('th[id^="pr"][id$='+week_day+']').each(function() {
      total += parseFloat($(this).html());
    });
    $("#total_"+week_day).html(total);
        
    // Update Total TOTAL
    total = 0
    for(i=1;i<6;i++) {
      total += parseFloat($("#total_"+i).html());
    }
    total_perc = Math.round((total*100)/40)
    $("#total_total").html(total + ' ('+ total_perc +'%)');
  } else {
    error = false;
  } 
});

// In case the user wants to leave the page
//window.onbeforeunload = function (e) {
//    var e = e || window.event;
//    var msg = 'Are you sure you want to leave?';
//
//    // For IE and Firefox
//    if (e) {
//        e.returnValue = msg;
//    }
//
//    // For Safari / chrome
//    return msg;
//}


// this tells jquery to run the function below once the DOM is ready
$(document).ready(function() {
	// We TOTALIZE for every job hour there is in the document (PreLoad Sum Hours)
	$('.hours').trigger('focusout');
	
	$('.timeRep_proj').click(function(){
		$(this).toggleClass("collapsed");
		$(this).siblings().toggle();
	})
});