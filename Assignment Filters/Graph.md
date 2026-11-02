# Graph
/deviceManagement/assignmentFilters

# Create Assignment Filter
POST https://graph.microsoft.com/beta/deviceManagement/assignmentFilters
Content-Type: application/json


# JSON

{
  "@odata.type": "#microsoft.graph.deviceAndAppManagementAssignmentFilter",
  "displayName": "Windows - Corporate",
  "description": "Corporate Windows devices only",
  "platform": "windows10AndLater",
  "rule": "(device.deviceOwnership -eq \"Corporate\")",
  "roleScopeTags": [
    "0"
  ]
}
