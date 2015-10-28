shinyUI(fluidPage(
  tags$head(tags$script("(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                        m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
                        })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                        ga('create', 'UA-5650686-6', 'auto');
                        ga('send', 'pageview');")),
  
  includeCSS("style.css"),
  # Tytuł
  titlePanel("One-way ANOVA, power studies"),
  # Left panel
  sidebarLayout(
    sidebarPanel(
      sliderInput("g1", "Mean in the group 1", -3, 3, 0, 0.1),
      sliderInput("g2", "Mean in the group 2", -3, 3, 0, 0.1),
      sliderInput("g3", "Mean in the group 3", -3, 3, 0, 0.1),
      sliderInput("g4", "Mean in the group 4", -3, 3, 0, 0.1),
      textInput("seed","Set seed", "1313")
    ),
    # Right panel
    mainPanel(
      tabsetPanel(
        tabPanel('Plot', plotOutput("aov_plot")),
        tabPanel('AOV', verbatimTextOutput("aov_test")),
        tabPanel('Study of power', plotOutput("aov_ui"))
      )
    )
  )
))
