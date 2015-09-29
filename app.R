#------------------------------------------------------------------------------

rm(list=ls()) 
#source("./global.R",local= FALSE, echo=FALSE)
library(visNetwork)
library(jsonlite)
library(shiny)
#------------------------------------------------------------------------------

jay <- fromJSON(txt= "./data/worldcup2014-.json")
edges <- jay[["edges"]]
nodes <- jay[["nodes"]]
# nodes <- nodes[nodes$Country=="Italy",]

nodes$x <- nodes$y <- nodes$group <- nodes$value <- NULL
colnames(nodes) <- c("id", "label","group","title")
# nodes$label <- nodes$title <- NULL
nodes$title <- paste0("<p><b>", nodes$label,"</b><br>",nodes$group, " - ", nodes$title,"</p>")
sixteen <- c("Brazil",
             "Chile",
             "Colombia",
             "Uruguay",
             "France",
             "Nigeria",
             "Germany",
             "Algeria",
             "Netherlands",
             "Mexico",
             "Costa Rica",
             "Greece",
             "Argentina",
             "Switzerland",
             "Belgium",
             "United States")
# nodes <- nodes[nodes$group %in% sixteen,]


ui = fluidPage(
 tabPanel(title= "WorlCup 2014", column(11, visNetworkOutput("mynetwork",width="100%", height="700px") ) )
)

server = function(input, output) {
output$mynetwork <- renderVisNetwork({
visNetwork(nodes, edges) %>% visLayout(improvedLayout = TRUE, hierarchical = FALSE) %>%
   # visPhysics(solver="forceAtlas2Based",forceAtlas2Based=list(gravitationalConstant=-500000,centralGravity =0.001)) %>%
visPhysics(solver="barnesHut", barnesHut=list(gravitationalConstant= -80000, springConstant= 0.001,
 springLength= 200), stabilization= FALSE ) %>%
 visInteraction(   tooltipDelay= 10, hideEdgesOnDrag= TRUE) %>%
    visNodes(shape="dot")
})
}

shinyApp(ui=ui, server=server)
