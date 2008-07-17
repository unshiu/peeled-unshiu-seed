# =au携帯電話

require 'ipaddr'

module Jpmobile::Mobile
  # ==au携帯電話
  # CDMA 1X, CDMA 1X WINを含む。
  class Au < AbstractMobile
    # 対応するUser-Agentの正規表現
    USER_AGENT_REGEXP = /^(?:KDDI|UP.Browser\/.+?)-(.+?) /
    # 対応するメールアドレスの正規表現
    MAIL_ADDRESS_REGEXP = /.*@ezweb\.ne\.jp/
    
    # 簡易位置情報取得に対応していないデバイスID
    # http://www.au.kddi.com/ezfactory/tec/spec/eznavi.html
    LOCATION_UNSUPPORTED_DEVICE_ID = ["PT21", "TS25", "KCTE", "TST9", "KCU1", "SYT5", "KCTD", "TST8", "TST7", "KCTC", "SYT4", "KCTB", "KCTA", "TST6", "KCT9", "TST5", "TST4", "KCT8", "SYT3", "KCT7", "MIT1", "MAT3", "KCT6", "TST3", "KCT5", "KCT4", "SYT2", "MAT1", "MAT2", "TST2", "KCT3", "KCT2", "KCT1", "TST1", "SYT1"]
    # GPS取得に対応していないデバイスID
    GPS_UNSUPPORTED_DEVICE_ID = ["PT21", "KC26", "SN28", "SN26", "KC23", "SA28", "TS25", "SA25", "SA24", "SN23", "ST14", "KC15", "SN22", "KC14", "ST13", "SN17", "SY15", "CA14", "HI14", "TS14", "KC13", "SN15", "SN16", "SY14", "ST12", "TS13", "CA13", "MA13", "HI13", "SN13", "SY13", "SN12", "SN14", "ST11", "DN11", "SY12", "KCTE", "TST9", "KCU1", "SYT5", "KCTD", "TST8", "TST7", "KCTC", "SYT4", "KCTB", "KCTA", "TST6", "KCT9", "TST5", "TST4", "KCT8", "SYT3", "KCT7", "MIT1", "MAT3", "KCT6", "TST3", "KCT5", "KCT4", "SYT2", "MAT1", "MAT2", "TST2", "KCT3", "KCT2", "KCT1", "TST1", "SYT1"]

    # EZ番号(サブスクライバID)があれば返す。無ければ +nil+ を返す。
    def subno
      @request.env["HTTP_X_UP_SUBNO"]
    end
    alias :ident_subscriber :subno

    # 位置情報があれば Position のインスタンスを返す。無ければ +nil+ を返す。
    def position
      return nil if params["lat"].blank? || params["lon"].blank?
      l = Jpmobile::Position.new
      l.options = params.reject {|x,v| !["ver", "datum", "unit", "lat", "lon", "alt", "time", "smaj", "smin", "vert", "majaa", "fm"].include?(x) }
      case params["unit"]
      when "1"
        l.lat = params["lat"].to_f
        l.lon = params["lon"].to_f
      when "0", "dms"
        raise "Invalid dms form" unless params["lat"] =~ /^([+-]?\d+)\.(\d+)\.(\d+\.\d+)$/
        l.lat = Jpmobile::Position.dms2deg($1,$2,$3)
        raise "Invalid dms form" unless params["lon"] =~ /^([+-]?\d+)\.(\d+)\.(\d+\.\d+)$/
        l.lon = Jpmobile::Position.dms2deg($1,$2,$3)
      else
        return nil
      end
      if params["datum"] == "1"
        # ただし、params["datum"]=="tokyo"のとき(簡易位置情報)のときは、
        # 実際にはWGS84系のデータが渡ってくる
        # http://www.au.kddi.com/ezfactory/tec/spec/eznavi.html
        l.tokyo2wgs84!
      end
      return l
    end

    # 画面情報を +Display+ クラスのインスタンスで返す。
    def display
      p_w = p_h = col_p = cols = nil
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENPIXELS']
        p_w, p_h = r.split(/,/,2).map {|x| x.to_i}
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_ISCOLOR']
        col_p = (r == '1')
      end
      if r = @request.env['HTTP_X_UP_DEVCAP_SCREENDEPTH']
        a = r.split(/,/)
        cols = 2 ** a[0].to_i
      end
      Jpmobile::Display.new(p_w, p_h, nil, nil, col_p, cols)
    end

    # デバイスIDを返す
    def device_id
      if @request.user_agent =~ USER_AGENT_REGEXP
        return $1
      else
        nil
      end
    end
    
    def model_name
      AU_DEVICE_ID_TO_DEVICE_NAME[device_id]
    end
    
    # 簡易位置情報取得に対応している場合は +true+ を返す。
    def supports_location?
      ! LOCATION_UNSUPPORTED_DEVICE_ID.include?(device_id)
    end
    
    # GPS位置情報取得に対応している場合は +true+ を返す。
    def supports_gps?
      ! GPS_UNSUPPORTED_DEVICE_ID.include?(device_id)
    end

    # cookieに対応しているか？
    def supports_cookie?
      true
    end
    
    # http://www.au.kddi.com/ezfactory/tec/spec/4_4.html
    # を参考にしてデバイスIDから機種名に変換するHashを作りました
    AU_DEVICE_ID_TO_DEVICE_NAME =
  {'CA13' => 'C409CA','CA14' => 'C452CA','CA21' => 'A3012CA','CA22' => 'A5302CA',
   'CA23' => 'A5401CA','CA23' => 'A5401CA II','CA24' => 'A5403CA','CA25' => 'A5406CA',
   'CA26' => 'A5407CA','CA27' => 'A5512CA','CA28' => 'G\'zOne TYPE-R','CA31' => 'W21CA/CA II',
   'CA32' => 'W31CA','CA33' => 'W41CA','CA34' => 'W42CA','CA35' => 'W43CA','CA36' => 'E03CA',
   'CA37' => 'W51CA','CA38' => 'W52CA','CA39' => 'W53CA','CA3A' => 'W61CA','DN11' => 'C402DE',
   'HI13' => 'C407H','HI14' => 'C451H','HI21' => 'C3001H','HI23' => 'A5303H','HI24' => 'A5303H II',
   'HI31' => 'W11H','HI32' => 'W21H','HI33' => 'W22H','HI34' => 'PENCK','HI35' => 'W32H','HI36' => 'W41H',
   'HI37' => 'W42H','HI38' => 'W43H/H II','HI39' => 'W51H','HI3A' => 'W52H','HI3B' => 'W53H',
   'KC13' => 'C414K/K II','KC14' => 'A1012K/K II','KC15' => 'A1013K','KC21' => 'C3002K',
   'KC22' => 'A5305K','KC23' => 'A1401K','KC24' => 'A5502K','KC25' => 'A5502K','KC26' => 'A1403K/B01K',
   'KC27' => 'A5515K','KC28' => 'A5521K','KC29' => 'A5526K','KC2A' => 'A5528K','KC31' => 'W11K','KC32' => 'W21K',
   'KC33' => 'W31K/K II','KC34' => 'W32K','KC35' => 'W41K','KC36' => 'W42K','KC37' => 'W43K',
   'KC38' => 'W44K/K II','KC39' => 'W51K','KC3A' => 'MEDIA SKIN','KC3B' => 'W53K','KC3D' => 'W61K',
   'KC3E' => 'W44K IIカメラなしモデル','KCT1' => 'TK01','KCT2' => 'TK02','KCT3' => 'TK0K','KCT4' => 'TK03',
   'KCT5' => 'TK04','KCT6' => 'TK05','KCT7' => 'TK11','KCT8' => 'TK12','KCT9' => 'TK21','KCTA' => 'TK22',
   'KCTB' => 'TK23','KCTC' => 'TK31','KCTD' => 'TK40','KCTE' => 'TK51','KCU1' => 'TK41','MA13' => 'C408P',
   'MA21' => 'C3003P','MA31' => 'W51P','MA32' => 'W52P','MA33' => 'W61P','MAT1' => 'TP01','MAT2' => 'TP01',
   'MAT3' => 'TP11','MIT1' => 'TD11','PT21' => 'A1405PT','PT22' => 'A1406PT','PT23' => 'A1407PT',
   'PT33' => 'W61PT','SA21' => 'A3011SA','SA22' => 'A3015SA','SA24' => 'A1302SA','SA25' => 'A1303SA',
   'SA26' => 'A5503SA','SA27' => 'A5505SA','SA28' => 'A1305SA','SA29' => 'A5522SA','SA2A' => 'A5527SA',
   'SA31' => 'W21SA','SA32' => 'W22SA','SA33' => 'W31SA/SA II','SA34' => 'W32SA','SA35' => 'W33SA/SA II',
   'SA36' => 'W41SA','SA37' => 'E02SA','SA38' => 'W43SA','SA39' => 'W51SA','SA3A' => 'W52SA','SA3B' => 'W54SA',
   'SH31' => 'W41SH','SH32' => 'W51SH','SH33' => 'W52SH','SH34' => 'W61SH','SN12' => 'C404S','SN13' => 'C406S',
   'SN14' => 'C404S','SN15' => 'C413S','SN16' => 'C413S','SN17' => 'C1002S','SN21' => 'A3014S','SN22' => 'A1101S',
   'SN23' => 'A1301S','SN24' => 'A5402S','SN25' => 'A5404S','SN26' => 'A1402S','SN27' => 'A1402S II',
   'SN28' => 'A1402S IIカメラ無し','SN29' => 'A1404S/S II','SN31' => 'W21S','SN32' => 'W31S','SN33' => 'W32S',
   'SN34' => 'W41S','SN35' => 'W32S','SN36' => 'W42S','SN37' => 'W43S','SN38' => 'W44S','SN39' => 'W51S',
   'SN3A' => 'W52S','SN3B' => 'W53S','SN3C' => 'W54S','ST11' => 'C403ST','ST12' => 'C411ST','ST13' => 'A1011ST',
   'ST14' => 'A1014ST','ST21' => 'A5306ST','ST22' => 'INFOBAR','ST23' => 'A5405SA','ST24' => 'A5507SA',
   'ST25' => 'talby','ST26' => 'Sweets','ST27' => 'A5514SA','ST28' => 'A5518SA','ST29' => 'Sweets pure',
   'ST2A' => 'A5520SA/SA II','ST2C' => 'Sweets cute','ST2D' => 'A5525SA','ST31' => 'W42SA','ST32' => 'W53SA',
   'ST33' => 'INFOBAR 2','ST34' => 'W62SA','SY12' => 'C401SA','SY13' => 'C405SA','SY14' => 'C412SA',
   'SY15' => 'C1001SA','SYT1' => 'TS01','SYT2' => 'TS02','SYT3' => 'TS11','SYT4' => 'TS31','SYT5' => 'TS41',
   'TS13' => 'C410T','TS14' => 'C415T','TS21' => 'C5001T','TS22' => 'A3013T','TS23' => 'A5301T',
   'TS24' => 'A5304T','TS25' => 'A1304T','TS25' => 'A1304T II','TS26' => 'A5501T','TS27' => 'A5504T',
   'TS28' => 'A5506T','TS29' => 'A5509T','TS2A' => 'A5511T','TS2B' => 'A5516T','TS2C' => 'A5517T',
   'TS2D' => 'A5523T','TS2E' => 'A5529T','TS31' => 'W21T','TS32' => 'W31T','TS33' => 'W32T','TS34' => 'W41T',
   'TS35' => 'neon','TS36' => 'W43T','TS37' => 'W44T/T II/T III','TS38' => 'W45T','TS39' => 'DRAPE',
   'TS3A' => 'W47T','TS3B' => 'W51T','TS3C' => 'W52T','TS3D' => 'W53T','TS3E' => 'W54T','TS3G' => 'W55T',
   'TS3H' => 'W56T','TST1' => 'TT01','TST2' => 'TT02','TST3' => 'TT03','TST4' => 'TT11','TST5' => 'TT21',
   'TST6' => 'TT22','TST7' => 'TT31','TST8' => 'TT32','TST9' => 'TT51'}
  end
end
