
error = false;

$('.hours').focusin(function() {
   last_value = $(this).val();
});

$('.hours').click(function() {
  if (this.value == 0) {
    $(this).val("");
  }
});

$('.hours').focusout(function() {

  // If user leaves blank, we put a zero
  if (this.value == "") {
    $(this).val("0");
    return false;
  }   // if user doesn't write a number
  else if (isNaN(this.value) || isNaN(parseFloat(this.value))) {
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
    $('td[id^="pr"][id$='+week_day+']').each(function() {
      total += parseFloat($(this).html());
    });
    $("#total_"+week_day).html(total);
        
    // Update Total TOTAL
    total = 0
    for(i=1;i<6;i++) {
      total += parseFloat($("#total_"+i).html());
    }
    $("#total_total").html(total);    

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


// Andy Langton's show/hide/mini-accordion - updated 23/11/2009
// Latest version @ http://andylangton.co.uk/jquery-show-hide

// this tells jquery to run the function below once the DOM is ready
$(document).ready(function() {

  // choose text for the show/hide link - can contain HTML (e.g. an image)
  var expand  = '<img src="/images/expand.png" />';
  var contract= '<img src="/images/contract.png" />';
  
  // append show/hide links
  $('th[id^=timeRep_proj_]').prepend('<a href="#" class="toggleLink">'+expand+'</a> ');
  
  // hide all of the elements with a class of 'toggle'
  $('.timeRep_job').hide();
  
  // change the link depending on whether the element is shown or hidden
  $('a.toggleLink').click(function() {
  
    if ($(this).html().search("expand") != -1) {
      $(this).html(contract);
    } else {
      $(this).html(expand);
    };
    
    // toggle the display
    $(this).parent().parent().siblings().toggle(1000);  
    
    // return false so any link destination is not followed
    return false;
  });
});

