module questions/question-view

imports questions/question-model
imports questions/question-ac

section toolbar

  template questionsTools(p: Project) {    
    projectButton(p)
    buttonGroup{
      navigate questions(p) [class="btn", title="Questions and answers for " + p.name] { "Q&A" }
      navigate newQuestion(p) [class="btn", title="Ask a question about " + p.name] { "Ask" }
    }
  }
  
  template questionsToolbar(p: Project) {    
    gridRow{
      gridSpan(12){
        pullLeft{ buttonToolbar{ questionsTools(p) } }
      }
    }
  }
  
  template questionToolbar(q: Question) {
    gridRow{
      gridSpan(12){
        pullLeft{ buttonToolbar{ questionsTools(q.project) } }
        pullRight{
          buttonToolbar{
            buttonGroup{
              navigate editQuestion(q) [class="btn",title="Edit question", style="height:14px;padding:7px;"] { iPencil }
            }
          }
        }
      }
    }
  }
 
section questions

  page questions(p: Project) {
    title { output(p.name) " Questions at YellowGrass" }
    bmain(p) {
      questionsToolbar(p)
      pageHeader{ "Questions about " output(p.name) }
      list{ 
        for(q: Question in p.questions) {
          listitem{ 
            navigate question(p, q.number) { output(q.title) }
          }
        }
      }
    }
  }

section question page

  page question(p: Project, number: Int) {
    var q := p.getQuestion(number);
    init{ if(q == null) { return questions(p); } }  
    var answers := q.answers.length;
    title { output(q.title) " Questions at YellowGrass" }
    bmain(p) {
      questionToolbar(q)
      pageHeader2{ output(q.title) }
      blockquote{ 
        output(q.description) 
        small{
            "Asked by " nav(q.author) 
            " on " output(q.created.format("d MMMM yyyy 'at' HH:mm"))
        }
      }
      if(answers == 0) {
        pageHeader2{ "No answers yet" }
      } else {
        pageHeader2{ 
          output(answers) if(answers == 1) { " Answer" } else { " Answers" } 
        }
        for(a: Answer in q.answers order by a.created asc) {
          blockquote{  
            output(a.text) 
            small{
                "Answered by " nav(a.author)   
                " on " output(a.created.format("d MMMM yyyy 'at' HH:mm"))
            }
          }
        } separated-by{ hrule }
      }
      if(q.open) {
        answerQuestion(q) 
      } else {
        par{ "Question is closed" }
      }
    }
  }
  
  page newQuestion(p: Project) {
    var title: String;
    var description: WikiText;
    action save() { 
      var q := p.newQuestion(title, description);
      return question(p, q.number); 
    }
    bmain(p) {
      questionsToolbar(p)
      pageHeader{ "Ask Question about " output(p.name) }
      horizontalForm{ 
        controlGroup("Title") { input(title)[class="span8"] }
        controlGroup("Description") { input(description) }
        formActions{
          submitlink save() [class="btn btn-primary"]{ "Post" } " "
          navigate project(p) [class="btn"] { "Cancel" }
        }
      }
    }
  }
 
  page editQuestion(q: Question) {
    action save() { 
      return question(q.project, q.number);
    } 
    bmain(q.project) {
      questionToolbar(q)
      pageHeader{ "Edit Question '" output(q.title) "'" }
      horizontalForm{ 
        controlGroup("Title") { input(q.title)[class="span8"] }
        controlGroup("Description") { input(q.description) }
        formActions{
          submitlink save() [class="btn btn-primary"]{ "Post" } " "
          navigate question(q.project, q.number) [class="btn"] { "Cancel" }
        }
      }
    }
  }
   
section answering questions

  template answerQuestion(q: Question) {
    var text : WikiText
    action save() {
      q.answer(text); 
    } 
    pageHeader2{ "Your Answer" } 
    horizontalForm{
      input(text) [placeholder="Your Answer"]
      formActions{ 
        submitlink save() [class="btn btn-primary"] { "Save" }
      }
    }
  }
  
  