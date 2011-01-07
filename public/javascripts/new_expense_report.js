$(document).ready(function() {
	$("#expensereport_project_id").change(function() {	
		if (this.value) {
			$.getJSON('/projects/' + this.value + '/get_jobs', {},
				function(data){
					$("#expensereport_job_id").empty().append('<option></option');
					$.each(data.jobs, function(i,item){
						$("#expensereport_job_id").append('<option value="' + item.job.id + '">' + item.job.name + '</option>');
					});
					$('#expensereport_project_date_start').val(data.project.project.date_start);
					$('#expensereport_project_date_end').val(data.project.project.date_end);
			});
		} else {
			$("#expensereport_job_id").empty().append('<option></option');
		}
	});
});