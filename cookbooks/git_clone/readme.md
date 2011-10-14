## git-clone

A recipe for cloning a non app git repo.

### Prerequisites

Generate a new key pair by running the following (leave the passphrase blank):

    # ssh-keygen -t rsa 
    Generating public/private rsa key pair.
    Enter file in which to save the key (/Users/jimneath/.ssh/id_rsa): /tmp/id_rsa
    Enter passphrase (empty for no passphrase): 
    Enter same passphrase again: 
    
Copy the contents of /tmp/id_rsa to the files/default/deploy_key. Then add the contents of /tmp/id_rsa.pub as a key on github.

Also, don't forget to update the variables in recipes/default.rb
