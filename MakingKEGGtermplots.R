library("ggplot2")

#https://www.biostars.org/p/456294/ code from here



#Keeps ggplot from sorting alphabetically 
#https://stackoverflow.com/questions/20041136/avoid-ggplot-sorting-the-x-axis-while-plotting-geom-bar

BookKEGG$Conditions<-factor(BookKEGG$Conditions, levels =BookKEGG$Conditions)

#Customize

#make a plot that sorts into ontology
  ggplot(data = BookKEGG, aes(x = GeneRatio, y = Conditions, 
                        color = `p.adjust`, size = Counts)) + 
  geom_point() +
  scale_color_gradient(low = "red", high = "blue") +
  theme_bw(base_size =9) + 
  ylab("") + theme(axis.text.y = element_text(size=10, 
                                               color="Black", 
                                               face="bold",
                                               angle=0)) + xlab("GeneRatio") + 
  ggtitle("")+ guides(size = guide_legend(order=1))
  
ggsave("/Users/FreddyMappin/Desktop/keggplot.png", width = 7, height = 5, units = "in", dpi=300)


#https://www.biostars.org/p/456294/ code from here

#https://cmdlinetips.com/2021/05/tips-to-customize-text-color-font-size-in-ggplot2-with-element_text/#legendtitle


