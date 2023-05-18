
class BaseApi{

 static String baseUrl = 'http://mobyottadevelopers.online/hyamservices/api';
 static String login = '/guardlogin.php';
 static String getAssignedJobById = '/getJobsByGuardID.php';
 static String getGuardByID = '/getGuardByID.php';
 static String getAllGuards = '/getAllGuards.php';
 static String sendScanReport = '/sendScanReport.php';
 static String startJob = '/startJob.php';
 static String endJob = '/endJob.php';
 static String changeJobStatus = '/changeJobStatus.php';
 static String getAllIncomingJobs = '/getAllJobs.php';
 static String getJobByID = '/getJobByID.php';
 static String getReportsByJobID = '/getReportsByJobID.php';
 static String assignJobToGuard = '/assignJobToGuard.php';
 static String sendIncidentReport = '/sendIncidentReport.php';
 static String getIncidentsByJobAndGuard = '/getIncidentsByJobAndGuard.php';
 static String sendActivityLog = '/sendActivityLog.php';
 static String getActivityLogByGuardAndJob = '/getActivityLogByGuardAndJob.php';

}