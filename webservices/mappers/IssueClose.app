module webservices/mappers/IssueClose
function mapperEditedIssueClose ( ent : IssueClose , json : JSONObject ) : Void
{
  var temp := json.getJSONObject("actor") ;
  if ( temp != null )
  {
    var localent := ( loadEntity("User", temp.getString("id").parseUUID()) as User ) ;
    if ( localent != null )
    {
      ent.actor := localent;
    }
  }
  else
  {
    ent.actor := null;
  }
  ent.moment.setTime(json.getLong("moment") * 1000L);
}