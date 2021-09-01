const mdtApp = new Vue({
    el: "#content",
    data: {
        page: "loader",
        durum: 0,
        bulunma: 0,
        changePage(page) {
            this.page = page;
            if (page == "arananlar") {
                sleep(1)
                this.arananAra();
            }
        },
        sifre() {
            if (this.giris_sifre == "4546") {
                sleep(300)
                this.changePage("anasayfa")
            }else{
                this.giris_cevap = "Yanlış şifre!"
            }
        },
        kapat() {
            this.changePage("loader")
            this.giris_sifre = null
            $.post('http://laot-polismdt/kapat', JSON.stringify({}));
        },
        OffenderSearch() {
            if (this.offender_search) {

                this.offender_results.query = this.offender_search;
                $.post('http://laot-polismdt/performOffenderSearch', JSON.stringify({
                    query: this.offender_search
                }));

                this.offender_results.results = false;
                return;
            }
        },
        kisiSearch() {
            if (mdtApp.durum == 0) { 
                if (this.kisi_search) {

                    this.kisi_results.query = this.kisi_search;
                    $.post('http://laot-polismdt/kisiSearch', JSON.stringify({
                        query: this.kisi_search
                    }));
    
                    this.kisi_results.results = false;
                    return;
                }
             }
        },
        anasayfaSearch() {
            if (mdtApp.durum == 0) { 
                if (this.kisi_search) {

                    this.anasayfa_results.query = this.kisi_selected.firstname + this.kisi_selected.lastname;
                    $.post('http://laot-polismdt/performanasayfaSearch', JSON.stringify({
                        query: this.kisi_selected.firstname + ' ' + this.kisi_selected.lastname + ''
                    }));

                    this.anasayfa_results.results = false;
                    return;
                }
            }
        },
        vehicleNotSearch(plate) {
            if (mdtApp.durum == 0) { 
                if (plate) {

                    this.vehiclenot_results.query = plate;
                    $.post('http://laot-polismdt/vehicleNotSearch', JSON.stringify({
                        query: plate,
                    }));

                    this.vehiclenot_results.results = false;
                    return;
                }
            }
        },
        lisansSearch() {
            if (mdtApp.durum == 0) { 
                if (this.kisi_search) {

                    this.lisans_results.query = this.kisi_selected.identifier;
                    $.post('http://laot-polismdt/lisansSearch', JSON.stringify({
                        query: this.kisi_selected.identifier
                    }));

                    this.lisans_results.results = false;
                    return;
                }
            }
        },
        arananAra() {
            if (mdtApp.durum == 0) { 

                $.post('http://laot-polismdt/arananAra', JSON.stringify({
                    query: this.kisi_selected.firstname + ' ' + this.kisi_selected.lastname + '',
                }));

                this.aranma_results.results = false;
                return;
            }
        },
        telefonNo() {
            if (mdtApp.durum == 0) { 
                if (this.telefon_search) {

                    this.telefon_results.query = this.telefon_search;
                    $.post('http://laot-polismdt/telefonSearch', JSON.stringify({
                        query: this.telefon_search
                    }));

                    this.telefon_results.results = false;
                    return;
                }
            }
        },
        VehicleSearch() {
            if (mdtApp.durum == 0) { 
                if (this.vehicle_search) {

                    this.vehicle_results.query = this.vehicle_search;
                    $.post('http://laot-polismdt/vehicleSearch', JSON.stringify({
                        plate: this.vehicle_search
                    }));

                    this.vehicle_results.results = false;
                    return;
                }
            }
        },
        OpenVehicleDetails(result) {
            if (mdtApp.durum == 0) { 
                $.post('http://laot-polismdt/getVehicle', JSON.stringify({
                    vehicle: result
                }));

                return;
            }
        },
        yeniDepo() {
            if (mdtApp.durum == 0) { 
                var date = new Date();
                $.post('http://laot-polismdt/depoMYSQL', JSON.stringify({
                    tarih: date,
                    esya: this.depo_new.esya,
                    elkoyan: this.depo_new.elkoyan,
                    elkoyulan: this.depo_new.elkoyulan,
                    sebep: this.depo_new.sebep
                }));
                return;
            }
        },
        yeniAranma() {
            if (mdtApp.durum == 0) { 
                $.post('http://laot-polismdt/aranmaMYSQL', JSON.stringify({
                    isimsoyisim: this.kisi_selected.firstname + ' ' + this.kisi_selected.lastname + '',
                    sebep: this.aranma_new.sebep
                }));
                sleep(100)
                this.arananAra();
                return;
            }
        },
        delSabika() {
            if (mdtApp.durum == 0) { 
                $.post('http://laot-polismdt/delSabika', JSON.stringify({
                    id: this.anasayfa_selected.id,
                }));
                sleep(300)
                this.anasayfaSearch();
                return;
            }
        },
        delAranan(id) {
            if (mdtApp.durum == 0) { 
                if (id) {
                    $.post('http://laot-polismdt/delAranan', JSON.stringify({
                        id: id,
                    }));
                    return;
                }
            }
        },
        delVehicleNot(id) {
            if (mdtApp.durum == 0) { 
                if (id) {
                    $.post('http://laot-polismdt/delVehicleNot', JSON.stringify({
                        id: id,
                    }));
                    sleep(300)
                    this.vehicleNotSearch(this.vehicle_selected.plate);
                    return;
                }
            }
        },
        yeniSabika() {
            if (mdtApp.durum == 0) { 
                var date = new Date();
                $.post('http://laot-polismdt/sabikaMYSQL', JSON.stringify({
                    tarih: date,
                    isimsoyisim: this.kisi_selected.firstname + ' ' + this.kisi_selected.lastname + '',
                    sabika: this.anasayfa_new.sabika,
                    ceza: this.anasayfa_new.ceza,
                }));
                sleep(100)
                this.anasayfaSearch();
                return;
            }
        },
        yeniVehicleNot() {
            if (mdtApp.durum == 0) { 
                var date = new Date();
                $.post('http://laot-polismdt/vehicleNotMYSQL', JSON.stringify({
                    plate: this.vehicle_selected.plate,
                    notx: this.vehiclenot_new.notx,
                }));
                return;
            }
        },
        giris_sifre: "",
        giris_cevap: null,
        depo_new: {
            esya: null,
            elkoyan: null,
            elkoyulan: null,
            sebep: null
        },
        offender_search: "",
        offender_results: {
            query: "",
            results: false
        },
        offender_selected: {
            id: null,
            tarih: null,
            elkoyan: null,
            elkoyulan: null,
            esya: null,
            sebep: null,
            author: null
        },
        anasayfa_new: {
            sabika: null,
            ceza: null
        },
        aranma_new: {
            sebep: null
        },
        anasayfa_search: "",
        anasayfa_results: {
            query: "",
            results: false
        },
        anasayfa_selected: {
            id: null,
            tarih: null,
            isimsoyisim: null,
            sabika: null,
            ceza: null,
            author: null
        },
        vehicle_search: "",
        vehicle_results: {
            query: "",
            results: false
        },
        vehicle_selected: {
            plate: null,
            type: null,
            owner: null,
            owner_id: null,
            model: null,
            color: null
        },/* */
        kisi_search: "",
        kisi_results: {
            query: "",
            results: false
        },
        kisi_selected: {
            identifier: null,
            firstname: null,
            lastname: null,
            sex: null,
            dateofbirth: null,
            phone_number: null,
            job: null,
            height: null,
            bank: null
        },
        lisans_results: {
            query: "",
            results: false
        },
        vehiclenot_results: {
            query: "",
            results: false,
            id: null
        },
        vehiclenot_new: {
            notx: null
        },
        aranma_results: {
            query: "",
            results: false
        },
        telefon_search: "",
        telefon_results: {
            query: "",
            results: false
        },
    }
});

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
  }

  document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        mdtApp.kapat()
    } else if (data.which == 13) { // enter
        /* stop enter key from crashing MDT in an input?  */
        var textarea = document.getElementsByTagName('textarea');
        if (!$(textarea).is(':focus')) {
            return false;
        }
    }
};

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "enable") {
                document.body.style.display = event.data.isVisible ? "block" : "none";
            } else if (event.data.type == "returnedPersonMatches") {
                mdtApp.offender_results.results = event.data.matches;
            } else if (event.data.type == "returnedanasayfaMatches") {
                mdtApp.anasayfa_results.results = event.data.matches;
            } else if (event.data.type == "returnedkisiMatches") {
                mdtApp.kisi_results.results = event.data.matches;
            } else if (event.data.type == "returnedlisansMatches") {
                mdtApp.lisans_results.results = event.data.matches;
            } else if (event.data.type == "returnedVehicleNotMatches") {
                mdtApp.vehiclenot_results.results = event.data.matches;
            } else if (event.data.type == "returnedArananMatches") {
                mdtApp.aranma_results.results = event.data.matches;
            } else if (event.data.type == "durum1") {
                mdtApp.durum = 1;
            } else if (event.data.type == "durum0") {
                mdtApp.durum = 0;
            } else if (event.data.type == "returnedTelefonMatches") {
                mdtApp.telefon_results.results = event.data.matches;
            } else if (event.data.type == "returnedVehicleMatches") {
                mdtApp.vehicle_results.results = event.data.matches;
                mdtApp.vehicle_selected = {
                    id: null,
                    plate: null,
                    type: null,
                    owner: null,
                    owner_id: null,
                    model: null,
                    color: null
                };
            } else if (event.data.type == "returnedVehicleDetails") {
                mdtApp.vehicle_selected = event.data.details;
                mdtApp.vehicle_search = mdtApp.vehicle_selected.plate;
            /*} else if (event.data.type == "returnedlaotMatches") {
                mdtApp.laot_results.results = event.data.matches;*/
            };
        });
    };
};
