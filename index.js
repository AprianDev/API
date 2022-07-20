const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const mysql = require('mysql');
const e = require('express');
 
// parse application/json
app.use(bodyParser.json());
 
//create database connection
const conn = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'test_db'
});
 
//connect to database
conn.connect((err) =>{
    if(err) throw err;
    console.log('Mysql Connected...');
});
 
//tampilkan semua data User
app.get('/api/user',(req, res) => {
    let sql = "call getDataUser()";
    let query = conn.query(sql, (err, results) => {
        if(err) throw err;
        res.send(JSON.stringify({"status": 200, "error": null, "response": results}));
    });
});


//tampilkan data user berdasarkan id
app.get('/api/user/:id',(req, res) => {
    if (req.params.id != "" && typeof req.params.id !== 'undefined'){
        let sql = "call getDataUserByID("+conn.escape(req.params.id)+")";
        let query = conn.query(sql, (err, results) => {
            if(err) throw err;
            res.send(JSON.stringify({"status": 200, "error": null, "response": results}));
        });
    }
    else {
        res.send(JSON.stringify({"status": 400, "error": 'yes', "response": "Parameter id cannot empty"}));
    }
});
 
//Sign UP
app.post('/api/sign_up',(req, res) => {
    if (req.body.username != "" && req.body.password != "" && req.body.name != "" && req.body.email != "" && typeof req.body.name !== 'undefined' && typeof req.body.email !== 'undefined' && typeof req.body.username !== 'undefined' && typeof req.body.password !== 'undefined'){
        let sql = "call checkIdLogin("+conn.escape(req.body.username)+")";
        let query = conn.query(sql, (err, results,fields) => {
            if(err) throw err;
            var resultArray = Object.values(JSON.parse(JSON.stringify(results)));
            if (resultArray[0][0].jml == 0){
                let sql = "call insertUser('"+req.body.name+"','"+req.body.email+"','"+req.body.phone+"','"+req.body.address+"')";
                let query = conn.query(sql, (err, results) => {
                    if(err) throw err;
                    let sql_2 = "(SELECT id from user where name = '"+req.body.name+"' AND email = '"+req.body.email+"' AND phone = '"+req.body.phone+"' and address = '"+req.body.address+"' order by id DESC limit 1)";
                    let sql_3 = "call insertLogin('"+req.body.username+"',md5('"+req.body.password+"'),"+sql_2+")";
                    let query2 = conn.query(sql_3, (err,results) => {
                        if(err) throw err;
                        res.send(JSON.stringify({"status": 200, "error": null, "response": "Sign up success"}));
                    });
                });
            }
            else {
                res.send(JSON.stringify({"status": 400, "error": "yes", "response": "Username Allready Created"}));
            }
        });
    }
    else {
        res.send(JSON.stringify({"status": 400, "error": "yes", "response": "Parameter Username,Password,Name,Email cannot empty"}));
    }
});
 
//Sign in
app.post('/api/sign_in',(req, res) => {
    if (req.body.username != "" && typeof req.body.username !== 'undefined' && req.body.password != "" && typeof req.body.password !== 'undefined'){
    let sql = "call signIn("+conn.escape(req.body.username)+",md5('"+req.body.password+"'))";
    let query = conn.query(sql, (err, results) => {
        if(err) throw err;
        var resultArray = Object.values(JSON.parse(JSON.stringify(results)));
        if (resultArray[0][0].jml > 0){
            let sql_id = "(SELECT user_id from login where username = "+conn.escape(req.body.username)+" AND password = md5('"+req.body.password+"'))";
            let sql = "call getDataUserByID("+sql_id+")";
            let query = conn.query(sql, (err, results) => {
                if(err) throw err;
                
                var resultArray = Object.values(JSON.parse(JSON.stringify(results)));
                var result = [];
                resultArray[0][0].message = "Login Success with data";
                result = resultArray[0][0];
                res.send(JSON.stringify({"status": 200, "error": null, "response": result}));
            });
        }
        else {
            res.send(JSON.stringify({"status": 400, "error": 'yes', "response": "Wrong Username / Password"}));
        }
    });
    }
    else {
        res.send(JSON.stringify({"status": 400, "error": 'yes', "response": "Parameter Username and Password cannot empty"}));
    }
  });

//Server listening
app.listen(3000,() =>{
    console.log('Server started on port 3000...');
});