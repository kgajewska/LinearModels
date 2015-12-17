#add additional slider where you can adjust the number of observations: more observations, what happens 
#to power of the test? also higher?

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$aov_plot <- renderPlot({
    set.seed(as.numeric(input$seed))
    
    N <- 20
    y1 <- rnorm(N, input$g1, 1)
    y2 <- rnorm(N, input$g2, 1)
    y3 <- rnorm(N, input$g3, 1)
    y4 <- rnorm(N, input$g4, 1)
    
    y <- c(y1, y2, y3, y4)
    g <- rep(1:4, each=N)
    
    df <- data.frame(y, g=factor(g))
    
    ggplot(df, aes(x=g, y=y)) + 
      geom_boxplot() +
      geom_point(position=position_jitter(.2,0))
  })

  output$aov_test <- renderPrint({
    set.seed(as.numeric(input$seed))
    
    N <- 20
    y1 <- rnorm(N, input$g1, 1)
    y2 <- rnorm(N, input$g2, 1)
    y3 <- rnorm(N, input$g3, 1)
    y4 <- rnorm(N, input$g4, 1)
    
    y <- c(y1, y2, y3, y4)
    g <- rep(1:4, each=N)
    
    df <- data.frame(y, g=factor(g))
    
    cat("\n# -------------- aov \n")
    print(summary(aov(y~g, data=df)))

    cat("\n# -------------- lm \n")
    print(summary(lm(y~g, data=df)))
  })
  
  
  output$aov_ui <- renderPlot({
    set.seed(as.numeric(input$seed))
    
    N <- 20
    M <- 100
    pvals <- replicate(M, {
      y1 <- rnorm(N, input$g1, 1)
      y2 <- rnorm(N, input$g2, 1)
      y3 <- rnorm(N, input$g3, 1)
      y4 <- rnorm(N, input$g4, 1)
      
      y <- c(y1, y2, y3, y4)
      g <- rep(1:4, each=N)
      
      df <- data.frame(y, g=factor(g))
      summary(aov(y~g, data=df))[[1]][1,5]
    })
    
    df <- data.frame(p=pvals)
    
    ggplot(df, aes(x=p)) +
      geom_histogram() + 
      xlim(0,1) +
      ggtitle(paste0(round(100*mean(pvals < 0.05),1), "% of p-values smaller than 0.05 \n\n", 
                     round(100*mean(pvals >= 0.05),1), "% of p-values larger than 0.05"))
      
  })
  
  output$aov_ui1 <- renderPlot({
    set.seed(as.numeric(input$seed))
    
    N <- as.numeric(input$obs)
    M <- 100
    pvals <- replicate(M, {
      y1 <- rnorm(N, input$g1, 1)
      y2 <- rnorm(N, input$g2, 1)
      y3 <- rnorm(N, input$g3, 1)
      y4 <- rnorm(N, input$g4, 1)
      
      y <- c(y1, y2, y3, y4)
      g <- rep(1:4, each=N)
      
      df <- data.frame(y, g=factor(g))
      summary(aov(y~g, data=df))[[1]][1,5]
    })
    
    df <- data.frame(p=pvals)
    
    ggplot(df, aes(x=p)) +
      geom_histogram() + 
      xlim(0,1) +
      ggtitle(paste0(round(100*mean(pvals < 0.05),1), "% of p-values smaller than 0.05 \n\n", 
                     round(100*mean(pvals >= 0.05),1), "% of p-values larger than 0.05"))
    
  })
  
  output$aov_ui2 <- renderPlot({
    set.seed(as.numeric(input$seed))
    
    N <- as.numeric(input$obs)
    M <- 100
    pvals <- replicate(M, {
      y1 <- rnorm(N, input$g1, input$v1)
      y2 <- rnorm(N, input$g2, input$v2)
      y3 <- rnorm(N, input$g3, input$v3)
      y4 <- rnorm(N, input$g4, input$v4)
      
      y <- c(y1, y2, y3, y4)
      g <- rep(1:4, each=N)
      
      df <- data.frame(y, g=factor(g))
      summary(aov(y~g, data=df))[[1]][1,5]
    })
    
    df <- data.frame(p=pvals)
    
    ggplot(df, aes(x=p)) +
      geom_histogram() + 
      xlim(0,1) +
      ggtitle(paste0(round(100*mean(pvals < 0.05),1), "% of p-values smaller than 0.05 \n\n", 
                     round(100*mean(pvals >= 0.05),1), "% of p-values larger than 0.05"))
    
  })
  
  output$aov_ui3 <- renderPlot({
    set.seed(as.numeric(input$seed))
    cat(input$distr)
    distr <- base::get(input$distr)
    N <- as.numeric(input$obs)
    M <- 100
    pvals <- replicate(M, {
      y1 <- distr(N, input$g1)
      y2 <- distr(N, input$g2)
      y3 <- distr(N, input$g3)
      y4 <- distr(N, input$g4)
      
      y <- c(y1, y2, y3, y4)
      g <- rep(1:4, each=N)
      
      df <- data.frame(y, g=factor(g))
      summary(aov(y~g, data=df))[[1]][1,5]
    })
    
    df <- data.frame(p=pvals)
    
    ggplot(df, aes(x=p)) +
      geom_histogram() + 
      xlim(0,1) +
      ggtitle(paste0(round(100*mean(pvals < 0.05),1), "% of p-values smaller than 0.05 \n\n", 
                     round(100*mean(pvals >= 0.05),1), "% of p-values larger than 0.05"))
    
  })
  
})
