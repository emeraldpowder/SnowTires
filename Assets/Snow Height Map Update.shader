Shader "Snow Height Map Update"
{
    Properties
    {
        _DrawBrush ("Brush", 2D) = "white" {}
    }

    SubShader
    {
        Lighting Off
        Blend One Zero
        
        Pass
        {
            CGPROGRAM
            #include "UnityCustomRenderTexture.cginc"
            #pragma vertex CustomRenderTextureVertexShader
            #pragma fragment frag
            #pragma target 3.0
            
            sampler2D _DrawBrush;
            float4 _DrawPosition;
            float _DrawAngle;
            float _RestoreAmount;
            
            float4 frag(v2f_customrendertexture IN) : COLOR
            {
                // Это цвет текущего пикселя карты высот в предыдущий фрейм, до нашего апдейта
                float4 previousColor = tex2D(_SelfTexture2D, IN.localTexcoord.xy);
                
                // Считаем по каким координатам взять пиксель маски-кисти для текущего пикселя карты высот
                float2 pos = IN.localTexcoord.xy - _DrawPosition;
                
                float2x2 rot = float2x2(cos(_DrawAngle), -sin(_DrawAngle),
                                        sin(_DrawAngle), cos(_DrawAngle));
                pos = mul(rot, pos);
                pos /= 0.1;
                pos += float2(0.5, 0.5);
                
                // И берём этот цвет (если он вообще вышел за пределы текстуры маски-кисти, то будет белый, т.к. у текстуры стоит Wrap Mode: Clamp)
                float4 drawColor = tex2D(_DrawBrush, pos);
                
                // min можно заменить на умножение, тогда рисование будет ощущаться немного иначе. _RestoreAmount можно убрать чтобы снег не выпадал и текстура не восстанавливалась со временем
                return min(previousColor, drawColor) + _RestoreAmount;
            }
            ENDCG
        }
    }
}