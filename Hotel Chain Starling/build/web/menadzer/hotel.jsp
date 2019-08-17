<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="beans.Klijent"%>
<%@page import = "java.util.*" session="true"%>
<%@page import="java.io.*" %>
<%@page import="java.sql.*" %>
<%@page import="javax.servlet.*" %>
<%@page import="javax.servlet.http.*" %>
<%
    HttpSession sesija = request.getSession();
    Klijent user = (Klijent)sesija.getAttribute("user");
    if(request.getSession().getAttribute("user") != null && user.getPower().equals("Menadzer hotela"))
    {
        
    }
    else
    {
        request.setAttribute("popupid", 2);
        request.setAttribute("poruka", "Niste ulogovani ili niste menadzer hotela.Pristup odbijen!");
        RequestDispatcher rd = request.getRequestDispatcher("../klijent/index.jsp");
        rd.forward(request, response);  
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Kontrolna tabla</title>
        <meta charset="UTF-8">
        <link rel="shortcut icon" href="${pageContext.request.contextPath}/admin/images/favicon.png" type="image/x-icon"/>
        <link href='${pageContext.request.contextPath}/admin/fonts/fonts/fonts.css' rel='stylesheet' type='text/css'>
        <link href="${pageContext.request.contextPath}/admin/css/admin.css" rel="stylesheet" type="text/css"/>
        <link href="${pageContext.request.contextPath}/admin/fonts/css/all.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/material.blue-red.min.css">
        <script defer src="${pageContext.request.contextPath}/css/js/material.min.js"></script>
        <script src="${pageContext.request.contextPath}/admin/js/jquery.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/admin/js/js.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/admin/js/jquery.min.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/admin/js/js.js" type="text/javascript"></script>
        <script src="${pageContext.request.contextPath}/admin/js/sweetalert.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/js/sweetalert.css">
        <script>
        function error()  
        {    
            swal ("Error" ,  "${poruka}",  "error" );    
        }
        function success()  
        {   
            swal ("Success" ,  "${poruka}",  "success" );  
        }
        </script>
    </head>
    
<%
        if(request.getAttribute("poruka") != null)
        {
            if(Integer.parseInt(request.getAttribute("popupid").toString()) == 2)   
            {
            %>
<body onLoad="error()">
            <%
            }
                else if(Integer.parseInt(request.getAttribute("popupid").toString()) == 3)
                {
                %>
                    <body onLoad="success()">
                <%}
        }
        else
        {
        %>
<body>
    <%
        }
        %>
  <section class="navigation">
    <p class="title">
      <img style="height: 70px; width: 170px;" src="${pageContext.request.contextPath}/klijent/images/logo.png">
    <p><hr style="height: 1px; width:100%; max-width: 185px; margin: 0 auto;">

        <img class="profile-pic" src="${pageContext.request.contextPath}/admin/images/img_avatar.png" alt=""/>
        
         <%
        Connection con = null;
        Statement stmt = null;
        ResultSet rsc = null;
        try
        {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/starling", "root", "");
            stmt = con.createStatement();
            String upit = "select * from klijenti where kime='"+user.getUsername()+"'";
            rsc = stmt.executeQuery(upit);
            %>
            
            <%  while(rsc.next())
            { %>
            <p class="name"><%=rsc.getString("ime")%><p>
            <p class="name"><%=rsc.getString("vrsta")%><p>
            <%} %>
           
            <%
            rsc.close();
            stmt.close();
            con.close();
        }
        catch(Exception e){}

    %>
        
            <div class="function-wrapper">
              <a href="${pageContext.request.contextPath}/odjavljivanje">
              <button id="logout" class="function"><i class="material-icons">clear</i></button>
              <div class="mdl-tooltip" for="odjavljivanje">
                Odjavi se
              </div>
              </a>
            </div>

            <div class="options-wrapper">
              <div class="panel-option">
                <i class="material-icons">computer</i>
                <a href="${pageContext.request.contextPath}/menadzer/index.jsp"><p>Statistika</p></a>
              </div>

              <div class="panel-option active">
                <i class="material-icons">hotel</i>
                <a href="${pageContext.request.contextPath}/menadzer/hotel.jsp"><p>Hotel</p></a>
              </div>

              <div class="panel-option">
                <i class="material-icons">room</i>
                <a href="${pageContext.request.contextPath}/menadzer/sobe.jsp"><p>Sobe</p></a>
              </div>
              
              <div class="panel-option">
                <i class="material-icons">room</i>
                <a href="${pageContext.request.contextPath}/menadzer/tipovisoba.jsp"><p>Tipovi soba</p></a>
              </div>

              <div class="panel-option">
                <i class="material-icons">shopping_cart</i>
                <a href="${pageContext.request.contextPath}/menadzer/rezervacije.jsp"><p>Rezervacije</p></a>
              </div>
              <div>
  </section>

  <section class="page-content">
    <div class="header">
      <p class="big">Kontrolna tabla <span class="small">all informations about Starling Hotel Chain</span></p>
    </div>

    <div class="content">
      <br><br>
  <table class="tables">
    <thead>
      <tr>
        <th>ID</th>
        <th>Naziv</th>
        <th>Država</th>
        <th>Grad</th>
        <th>Adresa</th>
        <th>Opis</th>
        <th>Zvezde</th>
        <th>Slika</th>
        <th><center><i class="fa fa-edit" aria-hidden="true"></i></center></th>
      </tr>
    </thead>
    <tbody>
            
           <%    
        try
        {
            Connection conn = null;
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/starling", "root", "");

            ResultSet rs = null;  
            PreparedStatement ps=null;

            String sqlPagination="SELECT * FROM hoteli where ID="+user.getHotelID()+"";

            ps=conn.prepareStatement(sqlPagination);
            rs=ps.executeQuery();
            %>
            
            <%  int i=1;
            if(rs.first())
            { %>
            <tr>
                <td><%= rs.getInt("ID")%></td>
                <td><%= rs.getString("naziv")%></td>
                <td><%= rs.getString("drzava")%></td>
                <td><%= rs.getString("grad")%></td>
                <td><%= rs.getString("adresa")%></td>
                <td><textarea style="width: 100%; height: 100%; resize: none; background-color: transparent; border: none; overflow: none; " disabled><%= rs.getString("opis")%></textarea></td>
                <td><%= rs.getInt("zvezdice")%></td>
                <%
                            byte[] imgData = rs.getBytes("slika");
                            String encode = Base64.getEncoder().encodeToString(imgData);
                %>
                <td><img style="max-width: 200px; max-height: 200px;" src="data:image/jpeg;base64,<%=encode%>" alt=""/></td>
                <td><a class="button green" href="${pageContext.request.contextPath}/IzmeniHotel?id=<%=rs.getInt("ID")%>">IZMENI</a></td>
            </tr>
            
              <%}
                rs.close();
                stmt.close();
                con.close();
            }
            catch(Exception e)
            {
                e.printStackTrace();
            }
    %>
             </tbody>
        </table>
  </section>
    <script src="${pageContext.request.contextPath}/admin/js/js.js" type="text/javascript"></script>
</body>
</html>
