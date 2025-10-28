Class ZIRIS.DevHub.FHIR.FSLog Extends ZIRIS.DevHub.Portal.Template
{
Parameter Title As STRING [ Final ] = "FSLOG";

Parameter APPLICATION = "FSLOG";

Parameter CATEGORY = "FHIR";

ClassMethod OnPageHEAD() As %Boolean
{
	Do ##super()
	Write "<link rel=""shortcut icon"" href=""portal/ISC_IRIS_icon.ico"">"
	write "<link rel=""stylesheet"" href=""https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css"">"
	write "<link rel=""stylesheet"" href=""https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css"">"
	write "<script src=""https://code.jquery.com/jquery-3.7.0.js""></script>"
	write "<script src=""https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js""></script>"
	write "<script src=""https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js""></script>"
	Return $$$OK
}

ClassMethod OnRenderScreen() As %Status
{
	#define del "|"
	write "<body>"
	write "<div>"
	write "<img class=""portalLogo"" src=""portal/InterSystems IRIS.png"">"
	write "<br>"
	write "<h4 style=""font-family: 'Poppins', sans-serif;font-size: 22px;font-weight: 600;color: #1a1a1a;background: linear-gradient(to right, #f8f9fa, #e3f2fd);padding: 12px 20px;border-left: 5px solid rgb(51, 54, 149);border-radius: 8px;display: inline-block;box-shadow: 0 2px 5px rgba(0,0,0,0.08);"">FSLogChannel is <span style=""  background-color: rgb(51, 54, 149);  color: white;  padding: 2px 8px;  border-radius: 4px;  font-weight: 700;  margin-left: 5px;"">"
	write $O(^FSLogChannel(""))_"</span></h4>"
	write "</div>"
	write " <table id=""example"" class=""table table-striped"" style=""width:100%;padding: 0.1rem 0.1rem;font-size:12px;"">"
	write " <thead class='table-header'>"
	write "<tr>"
	set header = $listfromstring("Location,Type,Message,TimeStamp,jobNumber")
	set ptr=0
	while $listnext(header,ptr,head) {
		write "<th style='background-color:#333695;color:white;'>"_head_"</th>"
	}
	write "</tr>"
	write "</thead>"
	write "<tbody>"
	set key=""
	for  {
		set key = $order(^FSLOG(key), -1, record) quit:key=""
		set location = $piece(record, $$$del, 1)
		set timeStamp = $piece(record, $$$del, *)
		set jobNumber = $piece(location, "^", 3)
		write "<tr>"
		write "<td style=""padding:1px;"">"_location_"</td>"
		write "<td>"_ $piece(record, $$$del, 2)_"</td>"
		write "<td>"_$piece(record, $$$del, 3, *-1)_"</td>"
		write "<td>"_timeStamp_"</td>"
		write "<td>"_jobNumber_"</td>"
		write "</tr>"
	}
	write "</tbody>"
	write "</table>"
	write "</body>"
	;
	&HTML<
		<script language="javascript">
		$(document).ready(function(){
	        $('#example').DataTable();
	    })
		</script>
		>
	return $$$OK
}

}