generate_mc_groups <- function(attendees, all_dates, num_groups = 3){
  
  #################################
  ### Generate adjacency matrix ###
  #################################
  
  #Initialize list of group members
  full_members <- c("Alex",
                    "Haley",
                    "Scott",
                    "Arianna",
                    "Jesse",
                    "Holly",
                    "Russ",
                    "Lauren",
                    "Sam",
                    "Bronson",
                    "Mike",
                    "Carol",
                    "Steve",
                    "Martin",
                    "Jordyn",
                    "Tracy",
                    "Amanda",
                    "Tara",
                    "Kelsey",
                    "Amy"
  )
  members <- full_members[full_members %in% attendees]
  alex_haley_here <- ifelse("Alex" %in% members & "Haley" %in% members, TRUE, FALSE)
  group_dat <- data.frame(members = members, ID = 1:length(members))
  #Function to generate adjacency matrix
  gen_adj_matrix <- function(data){
    mat <- matrix(data = 0.01, nrow = nrow(data), ncol = nrow(data))
    diag(mat) <- 0
    return(mat)
  }
  #Function to iterate adjacency matrix
  #Takes a list with 3 groups
  iter_adj_matrix <- function(group_list, data, adj_mat){
    for(i in 1:length(group_list)){
      group_vec <- group_list[[i]]
      combs <- combn(group_vec,2)
      for(j in 1:ncol(combs)){
        this_pair <- combs[,j]
        these_IDs <- group_dat$ID[group_dat$members == this_pair[1] | group_dat$members == this_pair[2]]
        #Check to make sure both of these people are in the adjacency matrix
        if(length(these_IDs == 2)){
          adj_mat[these_IDs[1],these_IDs[2]] <- adj_mat[these_IDs[1],these_IDs[2]] + 1
          adj_mat[these_IDs[2],these_IDs[1]] <- adj_mat[these_IDs[2],these_IDs[1]] + 1
        }
      }
    }
    return(adj_mat)
  }
  
  #Generate adj matrix fully
  updated_adj_mat <- function(data, date_data){
    adj_mat <- gen_adj_matrix(data)
    for(k in length(date_data)){
      adj_mat <- iter_adj_matrix(date_data[[k]], data, adj_mat)
    }
    return(adj_mat)
  }
  
  adj_mat <- updated_adj_mat(group_dat, all_dates)
  
  ##################################################
  ### Generate possible groups and probabilities ###
  ##################################################
  
  #Generate "many" possible combinations of 3 group members - not all, because this is too computationally expensive
  group_number_vec <- rep(1:num_groups,length.out = nrow(group_dat))
  poss_combos <- matrix(data = 0, nrow = 10000, ncol = length(group_number_vec))
  for(l in 1:nrow(poss_combos)){
    invalid_sample <- 1
    while(invalid_sample){
      this_sample <- sample(group_number_vec, size = length(group_number_vec), replace = FALSE)
      #Check for Alex and Haley being in the same group, must be false if they are here
      invalid_sample <- ifelse(this_sample[1] == this_sample[2] & alex_haley_here, 1, 0)
    }
    poss_combos[l,] <- this_sample
  }
  #Generate list of lists of groups generated by the above
  gen_groups <- function(this_sample, data, num_groups){
    the_list <- list()
    for(i in 1:num_groups){
      the_list[[paste0("Group", i)]] <- data$members[this_sample == i]
    }
    return(the_list)
  }
  list_of_groups <-vector("list",10000)
  for(l in 1:nrow(poss_combos)){
    list_of_groups[[l]] <- gen_groups(poss_combos[l,],group_dat, num_groups = num_groups)
  }
  #Generate probabilities for each of these possible groups
  sum_adj_mat <- function(group_list, adj_mat){
    adj_sum <- 0
    for(i in 1:length(group_list)){
      group_vec <- group_list[[i]]
      combs <- combn(group_vec,2)
      for(j in 1:ncol(combs)){
        this_pair <- combs[,j]
        these_IDs <- group_dat$ID[group_dat$members == this_pair[1] | group_dat$members == this_pair[2]]
        #Check to make sure both of these people are in the adjacency matrix
        if(length(these_IDs == 2)){
          adj_sum <- adj_sum + adj_mat[these_IDs[1],these_IDs[2]]
          adj_sum <- adj_sum + adj_mat[these_IDs[2],these_IDs[1]]
        }
      }
    }
    return(adj_sum)
  }
  prob_data <- data.frame(adj_sum = numeric(length(list_of_groups)),
                          recip_adj_sum = numeric(length(list_of_groups)))
  for(l in 1:length(list_of_groups)){
    prob_data$adj_sum[l] <- sum_adj_mat(list_of_groups[[l]], adj_mat)
    prob_data$recip_adj_sum[l] <- 1/prob_data$adj_sum[l]
  }
  #Get final probabilities
  prob_data$probs <- prob_data$recip_adj_sum/sum(prob_data$recip_adj_sum)
  
  ################################
  ### Choose group and display ###
  ################################
  
  #Get group that is chosen
  chosen_arrange <- sample(1:length(list_of_groups), size = 1, replace = FALSE, prob = prob_data$probs)
  #message(list_of_groups[[chosen_arrange]])
  for(i in 1:num_groups){
  cat("Group ",i,": ", list_of_groups[[chosen_arrange]][[i]],"\n")
  }
}