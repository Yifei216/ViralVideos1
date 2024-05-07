using Plots

beta=0.4
beta1=0.1
alpha=0.03
gamma=0.002
b=0.02

ini=100
N=10000
global Seed=zeros(5,N)
Seed[1,:].=1
Seed[1,1:ini].=0
Seed[2,1:ini].=1
Seed[5,1:ini].=1

t=100
recordI=zeros(1,t)
recordS=zeros(1,t)
recordR=zeros(1,t)
recordAd=zeros(1,t)
recordSh=zeros(1,t)

for i=1:t
    global Seed
    Total=Int64(length(Seed[1,:]))
    Total_S=Int64(sum(Seed[1,:]))
    Total_I=Int64(sum(Seed[2,:]))
    Total_R=Int64(sum(Seed[3,:]))
    Total_Ad=Int64(sum(Seed[4,:]))
    Total_Sh=Int64(sum(Seed[5,:]))
    
    Address_I=zeros(1,Int64(Total_I))
    Address_I[1]=1
    address_index=2
    for j=2:Total
        if Seed[2,j]>0
            Address_I[address_index]=j
            address_index+=1
        end
    end

    for j=1:Int64(Total_I)
        if rand(1)[1]<(beta*Total_S/N)
            check=0
            while check<1
            choose=rand(1:Total)
                if Seed[1,choose]>0
                    check=1
                    Seed[1,choose]=0
                    if rand(1)[1]<beta1/beta
                        Seed[2,choose]=1
                    else
                        Seed[3,choose]=1
                    end
                    if Seed[4,Int64(Address_I[j])]>0
                       Seed[4,choose]=1
                    else
                       Seed[5,choose]=1
                    end
                end
            end
        end
    end
    ad=Int64(round(gamma*N^2/(N+Total_I)))

    j=0
    while j<ad
        choose=rand(1:Total)
        if Seed[1,choose]<1
        else
            Seed[1,choose]=0
            Seed[2,choose]=1
            Seed[4,choose]=1
            j+=1
        end
    end
    recordI[i]=Total_I
    recordS[i]=Total_S
    recordR[i]=Total_R
    recordAd[i]=0
    recordSh[i]=0

    for r=1:Total
        if Seed[3,r]>0
            if Seed[4,r]>0
                recordAd[i]+=1
            else
                recordSh[i]+=1
            end
        end
    end

    for j=1:Int64(Total_I)
        if rand(1)[1]<alpha
            Seed[2,Int64(Address_I[j])]=0
            Seed[3,Int64(Address_I[j])]=1
        end
    end

    newusers=Int64(round(b*N))
    newSeed=zeros(5,newusers)
    newSeed[1,:].=1
    Seed=[Seed newSeed]
end
tspan=1:t
#plot(tspan,recordS,"b',tspan,recordI,'r',tspan,recordR,'g',tspan,recordAd,'--")

#figure()
#plot(tspan,recordR,"g',tspan,recordAd,'r',tspan,recordSh,'b',tspan,recordAd+recordSh,'--")

#plot(tspan,recordS,"b',tspan,recordI,'r',tspan,recordR,'g',tspan,recordAd,'--")
plot(recordS) 
