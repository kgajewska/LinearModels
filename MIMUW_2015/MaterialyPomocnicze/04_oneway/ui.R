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
      checkboxGroupInput("distr", "Distribution:", choices=c("Normal"="rnorm", "Exponential"="rexp"), selected="Normal"),
      sliderInput("g1", "Mean in group 1", -3, 3, 0, 0.1),
      sliderInput("g2", "Mean in group 2", -3, 3, 0, 0.1),
      sliderInput("g3", "Mean in group 3", -3, 3, 0, 0.1),
      sliderInput("g4", "Mean in group 4", -3, 3, 0, 0.1),
      sliderInput("v1", "Variance in group 1", 0, 100, 0, 1),
      sliderInput("v2", "Variance in group 2", 0, 100, 0, 1),
      sliderInput("v3", "Variance in group 3", 0, 100, 0, 1),
      sliderInput("v4", "Variance in group 4", 0, 100, 0, 1),
      textInput("seed","Set seed", "1313"),
      textInput("obs", "The number of observations:", "20")
    ),
    # Right panel
    mainPanel(
      tabsetPanel(
        tabPanel('Plot', plotOutput("aov_plot")),
        tabPanel('AOV', verbatimTextOutput("aov_test")),
        tabPanel('Study of power', plotOutput("aov_ui")),
        tabPanel('Study of power with variable number of observations', plotOutput("aov_ui1")),
        tabPanel('Study of power with adjustable variances', plotOutput("aov_ui2")),
        tabPanel('Study of power with different distributions', plotOutput("aov_ui3"))
        )
      )
    )
  )
)
