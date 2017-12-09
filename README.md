# coup_challenge
Find Number of Fleet Engineers

# Local Setup
```
git clone https://github.com/cbar09/coup_challenge.git
cd coup_challenge
bundle install
ruby app.rb
```

### Live Demo:
https://coup-challenge.herokuapp.com

### Test API
```
curl -X POST -d '{"C":"12","P":"5","scooters":"10,15"}' https://coup-challenge.herokuapp.com/solve.json
Response: {"fleet_engineers":3}% 