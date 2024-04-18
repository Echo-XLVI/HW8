import psycopg2
import csv

def connection(query:str)-> list:
    conn=psycopg2.connect(host='localhost',port=5648,user='postgres',password='1380ACreZA46',database='musicshop')
    cursor = conn.cursor()
    cursor.execute(query)
    rows=cursor.fetchall()
    conn.commit()
    return rows

def save(filename:str,data:list):
    with open(filename,'w',newline='') as file:
        writer=csv.writer(file)
        writer.writerows(data)

if __name__=="__main__":
    data1=connection('''select a.albumid,m.count,m.average_time,m.sum_price from album a 
                        inner join (select albumid,count(musicid) as count,avg(m_time) as average_time,sum(price) as sum_price from music group by albumid) m on m.albumid = a.albumid
                        order by m.sum_price asc''')
    save("query1.csv",data1)

    data1=connection()
    save("query2.csv",data1)

    data1=connection('''select CONCAT(c.firstname, ' ', c.lastname) as artist_name from music m
                        inner join creator c on m.creatorid = c.creatorid  
                        group by c.firstname , c.lastname, m.m_style
                        having count(distinct m.m_style) >= 1  
                        and m.m_style = 'rock';''')
    
    save("query3.csv",data1)

    data1=connection('''select c.name ,f.date  from customer c 
                        inner join (select customerid,max(orderdate) as date from factor group by customerid ) f 
                        on c.customerid = f.customerid ''')
    save("query4.csv",data1)
    
    data1=connection()
    save("query5.csv",data1)

    data1=connection()
    save("query6.csv",data1)