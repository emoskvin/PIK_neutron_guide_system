function generic_bender_ell_scan(H,L,N)
Lb_min = 10; Lb_step = 10; Lb_max = 80;
n_chan_min = 1; n_chan_step = 1; n_chan_max = N;
model = mccode('../generic_guides/generic_curved_ell.instr','ncount=1e7');

name = 'H3-5 TOF bender ell scan lambda 2';
parameters.sample_width=0.01;
parameters.sample_height=0.01;
parameters.guide_start_width=0.03;
parameters.guide_start_height=0.15;
parameters.source_lambda_min=2.0;
parameters.source_lambda_max=2.1;
parameters.cold_regime=1;
parameters.m_out=6;
parameters.m_in=6;
parameters.m_str_side=6;
parameters.m_top=6;

parameters.sample_dist = 0.5;
parameters.nose_length = 4.8;
parameters.loutw = 0;
parameters.linw = 0;
parameters.linh = 12.3;
parameters.louth = 0.38;

model_str = mccode('../generic_guides/generic_straight_ell.instr','ncount=1e7');
parameters_str.guide_length = L;
parameters_str.m_str_side=6;
parameters_str.m_top=6;
parameters_str.sample_width=0.01;
parameters_str.sample_height=0.01;
parameters_str.guide_start_width=0.03;
parameters_str.guide_start_height=0.15;
parameters_str.source_lambda_min=2.0;
parameters_str.source_lambda_max=2.1;

parameters_str.sample_dist = 0.5;
parameters_str.nose_length = 4.8;
parameters_str.loutw = 0;
parameters_str.linw = 0;
parameters_str.linh = 12.3;
parameters_str.louth = 0.38;

results_str = iData(model_str,parameters_str);
sum_L_str = sum(results_str, 0);


figure
for n_chan = n_chan_min:n_chan_step:n_chan_max
    i=1;
    for Lb=Lb_min:Lb_step:Lb_max
        Ls = L - Lb;
        R = (Lb^2+2*Lb*Ls)/2/H;
        parameters.n_chan=n_chan;
        parameters.l_bender = Lb;
        parameters.l_straight = Ls;
        parameters.R_curv = R;
        results = iData(model,parameters);
        sum_Lb(i) = sum(results, 0);
        i = i+1;
    end
    sum_Lb=sum_Lb/sum_L_str;
    plot(Lb_min:Lb_step:Lb_max,sum_Lb,'LineWidth',2,'DisplayName',['n chan =' num2str(n_chan)]);
    hold on
end

title(name)
grid on
xlabel('Lb, m')
ylabel('transmission')
legend
legend('Location','south')
print(gcf,[name 'bend_scan'],'-dpng','-r300')
%matlab2tikz([name 'm_scan.tex'], 'width', '0.85\textwidth');
saveas(gcf,[name 'bend_scan.fig']);