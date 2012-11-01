module webservices/services/syncIssueClose
service webservice_generated_syncIssueClose ( )
{
  var json := JSONObject() ;
  var errors := JSONArray() ;
  var request := JSONArray(readRequestBody()) ;
  var result := JSONArray() ;
  for ( count : Int from 0 to request.length() )
    {
      var tl := ( loadEntity("Project", request.getJSONObject(count).getString("id").parseUUID()) as Project ) ;
      var timestamp := request.getJSONObject(count).getLong("lastSynced") ;
      for ( ent : IssueClose in getAllIssueCloseForProject(tl) where timestamp == 0 || ent.modified != null && ent.modified.getTime() > timestamp )
        {
          result.put(addDirtyFalse(ent.toJSON()));
        }
    }
  json.put("errors", errors);
  json.put("result", result);
  return json;
}