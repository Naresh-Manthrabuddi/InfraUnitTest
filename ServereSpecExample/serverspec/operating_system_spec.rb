require 'spec_helper'

describe service('ssh') do
  it { should be_running }
end
describe port(8080) do
  it { should be_listening }
end

  describe service('tomcat8') do
   it { should be_enabled }
   it { should be_running }
  end
describe file('/var/lib/tomcat8/webapps/TestRestWebservice.war') do
it { should exist }
end



