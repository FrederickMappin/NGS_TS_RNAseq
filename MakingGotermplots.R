library("ggplot2")

#https://www.biostars.org/p/456294/ code from here



#Keeps ggplot from sorting alphabetically 
#https://stackoverflow.com/questions/20041136/avoid-ggplot-sorting-the-x-axis-while-plotting-geom-bar

Book3$Conditions<-factor(Book3$Ontology, levels =Book$Ontology)

#Customize

#make a plot that sorts into ontology
  ggplot(data = Book3, aes(x = GeneRatio, y = Conditions, 
                        color = `p.adjust`, size = Counts)) + 
  geom_point() +
  scale_color_gradient(low = "red", high = "blue") +facet_grid(rows = vars(Ontology), scales="free", space ="free_y")+
  theme_bw(base_size =9) + 
  ylab("") + theme(axis.text.y = element_text(size=10, 
                                               color="Black", 
                                               face="bold",
                                               angle=0)) + xlab("GeneRatio") + 
  ggtitle("")
 
  
ggsave("/Users/FreddyMappin/Desktop/GOplotX.png", width = 7, height = 5, units = "in", dpi=300)


#https://www.biostars.org/p/456294/ code from here




