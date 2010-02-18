module issue/register

define page createIssue(p : Project) {
	var t : String := ""
	
	title{"YellowGrass.org - " output(p.name) " - New Issue"}
	main()
	define body(){
		var i := Issue{ type := improvementIssueType };
		var email : Email := ""
		<h1> "Post New " output(p.name) " Issue" </h1>
		
		par {
				placeholder issueSuggestionsBox {} // TODO does not work 
			}
		
		form { 
			par { label("Title") {
					input (t) [onkeyup := updateIssueSuggestions(t), autocomplete:="off"]
			}}
			par {
				label("Type") {
					select(i.type from [improvementIssueType, errorIssueType, featureIssueType, questionIssueType])
				}
			}
			par { label("Description") {input(i.description)} }
			par [align := "center"] { navigate(url("http://en.wikipedia.org/wiki/Markdown#Syntax_examples")){ "Syntax help" } }
			if(!securityContext.loggedIn) {
				par { label("Email") {input(email)} }
				par { <i> 	"Email addresses are used for notifications and questions only. "
							"Email addresses are never presented publicly."</i> 
				}
				par { captcha() }
			}
			
			par{
				navigate(project(p)) {"Cancel"}
				" "
				action("Post",post())
				action post(){
					i.submitted := now();
					i.project := p;
					i.number := newIssueNumber(p);
					i.open := true;
					i.reporter := securityContext.principal;
					i.email := email;
					if (p.members.length == 1) {
						i.tags.add(tag("@"+p.members.list().get(0).tag, p));
					}
					i.save();
					flush();
					i.notifyProjectMembers();
					return issue(p, i.number);
				}
			}
			action updateIssueSuggestions(t : String) {
				replace(issueSuggestionsBox, issueSuggestions(t, p));
			}
		}
	}
}

define ajax issueSuggestions(t : String, p : Project) {
	//var suggestions := searchIssue(t, 5);
	var suggestions := [Issue{ title := "bla"}]
	for(i : Issue in suggestions) {
		navigate(issue(p, i.number)){output(i.project.name) " - " output(i.title)}
	}
}