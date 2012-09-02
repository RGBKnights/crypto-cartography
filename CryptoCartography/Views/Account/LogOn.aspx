<%@ Page Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<CryptoCartography.Models.LogOnModel>" %>

<asp:Content ID="loginTitle" ContentPlaceHolderID="TitleContent" runat="server">
    Log On
</asp:Content>

<asp:Content ID="registerHead" ContentPlaceHolderID="HeadContent" runat="server">
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
    <script type="text/javascript" src="../../Scripts/jquery-1.4.1-vsdoc.js"></script>
    <script type="text/javascript">
        google.maps.Map.prototype.markers = new Array();

        google.maps.Map.prototype.addMarker = function (marker) {
            this.markers[this.markers.length] = marker;
        };

        google.maps.Map.prototype.getMarkers = function () {
            return this.markers
        };

        google.maps.Map.prototype.clearMarkers = function () {
            for (var i = 0; i < this.markers.length; i++) {
                this.markers[i].setMap(null);
            }
            this.markers = new Array();
        };

        $(document).ready(function () {
            var points = new Array();
            var latlng = new google.maps.LatLng(-34.397, 150.644);
            var myOptions = {
                zoom: 15,
                center: latlng,
                draggableCursor: 'crosshair', 
                draggingCursor: 'crosshair',
                mapTypeId: google.maps.MapTypeId.HYBRID
            };
            var map = new google.maps.Map(document.getElementById("map"), myOptions);

            // Try W3C Geolocation method (Preferred)
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    initialLocation = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
                    map.setCenter(initialLocation);
                }, function () {
                    alert("Can not set a default location you will have to navigate to one yourself.");
                });
            } else if (google.gears) {
                // Try Google Gears Geolocation
                var geo = google.gears.factory.create('beta.geolocation');
                geo.getCurrentPosition(function (position) {
                    initialLocation = new google.maps.LatLng(position.latitude, position.longitude);
                    map.setCenter(initialLocation);
                }, function () {
                    alert("Can not set a default location you will have to navigate to one yourself.");
                });
            }

            google.maps.event.addListener(map, 'click', function (event) {
                map.clearMarkers();

                var marker = new google.maps.Marker({
                    position: event.latLng,
                    map: map
                });
                map.addMarker(marker);

                points.push(event.latLng.toUrlValue(4));
            });

            $(":submit").click(function () {
                var password = points.join("");
                $("#Password").val(password);
            });

            $(":reset").click(function () {
                map.clearMarkers();
                points = new Array();
            });
        });
    </script>
</asp:Content>

<asp:Content ID="loginContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Log On</h2>
    <p>
        Please enter your username and password. <%: Html.ActionLink("Register", "Register") %> if you don't have an account.
    </p>

    <% using (Html.BeginForm()) { %>
        <%: Html.CheckBoxFor(m => m.RememberMe, new { style = "display:none;" })%>
        <%: Html.ValidationSummary(true, "Login was unsuccessful. Please correct the errors and try again.") %>
        <div>
            <fieldset>
                <legend>Account Information</legend>

                <div class="editor-label">
                    <%: Html.LabelFor(m => m.UserName) %>
                </div>
                <div class="editor-field">
                    <%: Html.TextBoxFor(m => m.UserName) %>
                    <%: Html.ValidationMessageFor(m => m.UserName) %>
                </div>
                
                <div class="editor-label">
                    <%: Html.LabelFor(m => m.Password) %>
                </div>
                <div class="editor-field">
                    <%: Html.PasswordFor(m => m.Password, new { style="display:none;"})%>
                    <%: Html.ValidationMessageFor(m => m.Password)%>

                    <div id="map" style="width:100%; height:400px;"></div>
                </div>
                
                <p>
                    <input type="submit" value="Log On" />
                    <input type="reset" value="Reset" />
                </p>
            </fieldset>
        </div>
    <% } %>
</asp:Content>
