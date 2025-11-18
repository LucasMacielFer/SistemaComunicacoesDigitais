function [bits, dataType] = FonteDeDados_Tab(parentTab)
    outputData = [];          
    outputType = 'Sequência aleatória de bits'; 
    imgExtension = '.jpg';    
    
    % Estrutura para guardar os handles dos componentes
    app = struct();
    
    % Encontrar o handle da figura principal para os comandos uiwait/uiresume
    figHandle = ancestor(parentTab, 'figure');
    
    % 1. Cria a Interface
    createComponents();
    
    % 2. PAUSA A EXECUÇÃO AQUI
    % O MATLAB fica parado nesta linha até receber um uiresume()
    uiwait(figHandle); 
    
    % 3. Quando o 'uiresume' dispara (no botão), o código continua aqui:
    
    % Verifica se a janela ainda existe (pode ter sido fechada no X)
    if isvalid(figHandle)
        bits = outputData;
        dataType = outputType;
        % Nota: Não precisamos de apagar a figura, apenas a função termina.
    else
        % Se o user fechou a janela principal (X), retorna vazio
        bits = [];
        dataType = [];
    end
    
    % --- Callbacks ---
    % Dropdown mudou
    function SelecioneafontededadosDropDownValueChanged(~, ~)
        outputType = app.SelecioneafontededadosDropDown.Value;
        % Lógica de visibilidade dos painéis (Mantida no código original)
        app.Panel_random.Visible = "off"; app.Panel_random.Enable = "off";
        app.Panel_text.Visible = "off";   app.Panel_text.Enable = "off";
        app.Panel_image.Visible = "off";  app.Panel_image.Enable = "off";
        app.Panel_audio.Visible = "off";  app.Panel_audio.Enable = "off";
        
        switch outputType 
            case 'Sequência aleatória de bits'
                app.Panel_random.Visible = "on"; app.Panel_random.Enable = "on";
            case 'Texto'
                app.Panel_text.Visible = "on";   app.Panel_text.Enable = "on";
            case 'Imagem'
                app.Panel_image.Visible = "on";  app.Panel_image.Enable = "on";
            case 'Áudio'
                app.Panel_audio.Visible = "on";  app.Panel_audio.Enable = "on";
        end
    end

    % Botão GERAR (Onde a magia acontece)
    function GerardadosbinriosButtonPushed(~, ~)
        basePath = fileparts(mfilename('fullpath'));
        try
            % ... (Sua lógica de seleção e encoding) ...
            switch outputType
                case 'Sequência aleatória de bits'
                        nLinhas = app.NmerodelinhasSpinner.Value;
                        nBits = app.NmerodebitsporlinhaSpinner.Value;
                        outputData = random_bitseq_generator(nLinhas, nBits);
                case 'Texto'
                    txt = app.EditField.Value;
                    if isempty(txt), txt = 'Sem texto'; end
                    outputData = ASCII_encoder(txt);
                case 'Áudio'
                    if app.UtilizardefaultCheckBox.Value
                        filename = fullfile(basePath, 'srcs', 'default.wav');
                        time = 3;
                    else
                        filename = fullfile(basePath, 'srcs', 'temp.wav');
                        time = app.TempodegravaosegundosSpinner.Value;
                    end
                    outputData = audio_encoder(filename, time);
                case 'Imagem'
                    if app.UtilizardefaultCheckBox_2.Value
                        filename = fullfile(basePath, 'srcs', 'default.jpg');
                    else
                        filename = fullfile(basePath, 'srcs', ['temp' imgExtension]);
                    end
                    [~, imgData] = image_encoder(filename);
                    outputData = imgData;
            end
            
            % SUCESSO! Libera o script principal
            uiresume(figHandle);
            
        catch err
            warndlg(['Erro ao gerar dados: ' err.message]);
            outputData = [];
        end
    end

    % Callbacks auxiliares (Ouvir, Gravar, Carregar)
    function OuvirButtonPushed(~, ~)
        basePath = fileparts(mfilename('fullpath'));
        if app.UtilizardefaultCheckBox.Value
            fn = fullfile(basePath, 'srcs', 'default.wav');
        else
            fn = fullfile(basePath, 'srcs', 'temp.wav');
        end
        if exist(fn, 'file'), audio_listen(fn); end
    end
    function GravarButtonPushed(~, ~)
        try
            dur = app.TempodegravaosegundosSpinner.Value;
            app.AgravarLabel.Visible = "on"; drawnow;
            rawData = audio_recorder(dur);
            app.AgravarLabel.Visible = "off";
            plot(app.UIAxes, rawData);
            app.UtilizardefaultCheckBox.Enable = "on";
        catch
            app.ERROLabel_2.Visible = "on";
        end
    end
    function CarregarButtonPushed(~, ~)
        try
            basePath = fileparts(mfilename('fullpath'));
            fn = app.EditField_2.Value;
            [~, ~, ext] = fileparts(fn);
            dest = fullfile(basePath, 'srcs', ['temp' ext]);
            copyfile(fn, dest);
            app.Image.ImageSource = dest;
            imgExtension = ext;
            app.UtilizardefaultCheckBox_2.Enable = "on";
        catch
            app.ERROLabel.Visible = "on";
        end
    end
    % Callback ao fechar a janela no 'X'
    function closeRequest(~, ~)
        uiresume(figHandle);
    end

    % --- Criação de Componentes ---
    function createComponents()
        pathToMLAPP = fileparts(mfilename('fullpath'));
        
        % 1. REMOVIDO: app.UIFigure = uifigure(...);
        % 2. DEFINIR PAIS (parentTab é o argumento de entrada)
        
        % Dropdown Label
        app.SelecioneafontededadosDropDownLabel = uilabel(parentTab); % PARENT: parentTab
        app.SelecioneafontededadosDropDownLabel.HorizontalAlignment = 'right';
        app.SelecioneafontededadosDropDownLabel.Position = [145 395 150 22];
        app.SelecioneafontededadosDropDownLabel.Text = 'Selecione a fonte de dados';
        
        % Dropdown
        app.SelecioneafontededadosDropDown = uidropdown(parentTab); % PARENT: parentTab
        app.SelecioneafontededadosDropDown.Items = {'Sequência aleatória de bits', 'Texto', 'Imagem', 'Áudio'};
        app.SelecioneafontededadosDropDown.ValueChangedFcn = @SelecioneafontededadosDropDownValueChanged;
        app.SelecioneafontededadosDropDown.Position = [310 395 187 22];
        app.SelecioneafontededadosDropDown.Value = 'Sequência aleatória de bits';
        
        % Título Label
        app.FontededadosLabel = uilabel(parentTab); % PARENT: parentTab
        app.FontededadosLabel.HorizontalAlignment = 'center';
        app.FontededadosLabel.FontSize = 18;
        app.FontededadosLabel.Position = [256 434 130 24];
        app.FontededadosLabel.Text = 'Fonte de dados';
        
        % Botão GERAR
        app.GerardadosbinriosButton = uibutton(parentTab, 'push'); % PARENT: parentTab
        app.GerardadosbinriosButton.ButtonPushedFcn = @GerardadosbinriosButtonPushed;
        app.GerardadosbinriosButton.Position = [257 25 127 23];
        app.GerardadosbinriosButton.Text = 'Gerar dados binários';
        
        % --- PAINEL TEXTO ---
        app.Panel_text = uipanel(parentTab); % PARENT: parentTab
        app.Panel_text.Enable = 'off'; app.Panel_text.Visible = 'off';
        app.Panel_text.BackgroundColor = [0.2196 0.2196 0.2196];
        app.Panel_text.Position = [25 271 592 105];
        
        app.EditField = uieditfield(app.Panel_text, 'text');
        app.EditField.Position = [85 30 424 22];
        
        lblTxt = uilabel(app.Panel_text);
        lblTxt.HorizontalAlignment = 'center';
        lblTxt.Position = [227 63 140 30];
        lblTxt.Text = {'Insira seu texto'; '(ASCII Extendida)'};
        
        % --- PAINEL IMAGEM ---
        app.Panel_image = uipanel(parentTab); % PARENT: parentTab
        app.Panel_image.Enable = 'off'; app.Panel_image.Visible = 'off';
        app.Panel_image.BackgroundColor = [0.2196 0.2196 0.2196];
        app.Panel_image.Position = [25 63 592 313];
        
        app.EditField_2 = uieditfield(app.Panel_image, 'text');
        app.EditField_2.Position = [85 247 424 22];
        
        lblImg = uilabel(app.Panel_image);
        lblImg.Text = 'Caminho da imagem:';
        lblImg.Position = [219 279 156 22];
        
        app.UtilizardefaultCheckBox_2 = uicheckbox(app.Panel_image);
        app.UtilizardefaultCheckBox_2.Text = 'Utilizar default';
        app.UtilizardefaultCheckBox_2.Position = [248 217 98 22];
        app.UtilizardefaultCheckBox_2.Value = true;
        
        app.Image = uiimage(app.Panel_image);
        app.Image.Position = [121 26 352 150];
        try app.Image.ImageSource = fullfile(pathToMLAPP, 'srcs', 'default.jpg'); catch; end
        
        app.CarregarButton = uibutton(app.Panel_image, 'push');
        app.CarregarButton.ButtonPushedFcn = @CarregarButtonPushed;
        app.CarregarButton.Position = [248 186 100 23];
        app.CarregarButton.Text = 'Carregar';
        
        app.ERROLabel = uilabel(app.Panel_image);
        app.ERROLabel.FontColor = [1 0 0]; app.ERROLabel.Visible = 'off';
        app.ERROLabel.Position = [277 5 40 22];
        app.ERROLabel.Text = 'ERRO';
        
        % --- PAINEL AUDIO ---
        app.Panel_audio = uipanel(parentTab); % PARENT: parentTab
        app.Panel_audio.Enable = 'off'; app.Panel_audio.Visible = 'off';
        app.Panel_audio.BackgroundColor = [0.2196 0.2196 0.2196];
        app.Panel_audio.Position = [25 63 592 313];
        
        app.UIAxes = uiaxes(app.Panel_audio);
        app.UIAxes.Position = [29 17 536 121];
        app.UIAxes.Box = 'on'; app.UIAxes.XTick = []; app.UIAxes.YTick = [];
        
        lblAudioTime = uilabel(app.Panel_audio);
        lblAudioTime.Text = 'Segundos:';
        lblAudioTime.Position = [250 258 80 22];
        
        app.TempodegravaosegundosSpinner = uispinner(app.Panel_audio);
        app.TempodegravaosegundosSpinner.Limits = [1 5];
        app.TempodegravaosegundosSpinner.Position = [342 258 100 22];
        app.TempodegravaosegundosSpinner.Value = 1;
        
        app.GravarButton = uibutton(app.Panel_audio, 'push');
        app.GravarButton.ButtonPushedFcn = @GravarButtonPushed;
        app.GravarButton.Position = [247 187 100 23];
        app.GravarButton.Text = 'Gravar';
        
        app.UtilizardefaultCheckBox = uicheckbox(app.Panel_audio);
        app.UtilizardefaultCheckBox.Text = 'Utilizar default';
        app.UtilizardefaultCheckBox.Position = [248 226 98 22];
        app.UtilizardefaultCheckBox.Value = true;
        
        app.OuvirButton = uibutton(app.Panel_audio, 'push');
        app.OuvirButton.ButtonPushedFcn = @OuvirButtonPushed;
        app.OuvirButton.Position = [248 153 100 23];
        app.OuvirButton.Text = 'Ouvir';
        
        app.AgravarLabel = uilabel(app.Panel_audio);
        app.AgravarLabel.FontColor = [1 0 0]; app.AgravarLabel.Visible = 'off';
        app.AgravarLabel.Position = [359 187 59 22];
        app.AgravarLabel.Text = 'A gravar...';
        
        app.ERROLabel_2 = uilabel(app.Panel_audio);
        app.ERROLabel_2.FontColor = [1 0 0]; app.ERROLabel_2.Visible = 'off';
        app.ERROLabel_2.Text = 'ERRO'; app.ERROLabel_2.Position = [274 9 45 15];
        
        % --- PAINEL RANDOM ---
        app.Panel_random = uipanel(parentTab); % PARENT: parentTab
        app.Panel_random.BorderType = 'none';
        app.Panel_random.BackgroundColor = [0.2196 0.2196 0.2196];
        app.Panel_random.Position = [25 271 592 105];
        
        lblBits = uilabel(app.Panel_random);
        lblBits.Text = 'Bits por linha:';
        lblBits.Position = [171 67 136 22];
        lblBits.HorizontalAlignment = 'right';
        
        app.NmerodebitsporlinhaSpinner = uispinner(app.Panel_random);
        app.NmerodebitsporlinhaSpinner.Limits = [100 100000];
        app.NmerodebitsporlinhaSpinner.Position = [322 67 100 22];
        app.NmerodebitsporlinhaSpinner.Value = 100;
        
        lblLinhas = uilabel(app.Panel_random);
        lblLinhas.Text = 'Num. Linhas:';
        lblLinhas.Position = [188 30 99 22];
        lblLinhas.HorizontalAlignment = 'right';
        
        app.NmerodelinhasSpinner = uispinner(app.Panel_random);
        app.NmerodelinhasSpinner.Limits = [1 10000];
        app.NmerodelinhasSpinner.Position = [302 30 100 22];
        app.NmerodelinhasSpinner.Value = 1;
        
        app.UIFigure.Visible = 'on'; % Mantém esta linha para mostrar o uifigure
    end
end