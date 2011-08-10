#!/usr/bin/env ruby

require 'fsr'
require "fsr/listener/outbound"
require 'securerandom'

class PlayAndGetDigitsDemo < FSR::Listener::Outbound
  SWEET_WAV = "/usr/local/freeswitch/sounds/music/8000/sweet.wav"
  NOT_WAV = "/usr/local/freeswitch/sounds/music/8000/not.wav"

  def session_initiated
    exten = @session.headers[:caller_caller_id_number]
    FSR::Log.info "*** Answering incoming call from #{exten}"

    answer do
      FSR::Log.info "*** Reading DTMF from #{exten}"

      play_and_get_digits(SWEET_WAV, NOT_WAV, chan_var: SecureRandom.uuid) do |digits|
        FSR::Log.info "*** Success, grabbed #{digits.to_s.strip} from #{exten}"
        speak("Got the DTMF of: #{digits.to_s.strip}") { hangup }
      end
    end
  end
end

FSR.start_oes! PlayAndGetDigitsDemo, port: 8084, host: "0.0.0.0"
